import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lima_soko/core/services/supabase_service.dart';
import 'package:lima_soko/domain/entities/payment.dart';
import 'package:lima_soko/domain/repositories/mpesa_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class MpesaServiceImpl implements MpesaService {
  final SupabaseClient _supabaseClient;
  final SupabaseService _supabaseService;

  MpesaServiceImpl(this._supabaseClient, this._supabaseService);

  // Placeholder for M-Pesa API base URL and consumer key/secret
  // In a real application, these would be loaded securely from environment variables
  static const String _mpesaBaseUrl = 'https://sandbox.safaricom.co.ke/mpesa/';
  static const String _consumerKey = 'YOUR_MPESA_CONSUMER_KEY';
  static const String _consumerSecret = 'YOUR_MPESA_CONSUMER_SECRET';
  static const String _lipaNaMpesaShortcode = '174379'; // Paybill or Till Number
  static const String _lipaNaMpesaPasskey = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b107ed920b8cdfdce1797c'; // Lipa Na M-Pesa Online Passkey
  static const String _callbackUrl = 'https://your-app.supabase.co/functions/v1/mpesa-callback'; // Your Supabase Edge Function URL

  Future<String> _getAccessToken() async {
    final String credentials = base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'));
    final response = await http.get(
      Uri.parse('${_mpesaBaseUrl}oauth/v1/generate?grant_type=client_credentials'),
      headers: {'Authorization': 'Basic $credentials'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'] as String;
    } else {
      throw Exception('Failed to get M-Pesa access token: ${response.body}');
    }
  }

  @override
  Future<Payment> initiateStkPush({
    required String phoneNumber,
    required double amount,
    required String orderId,
    required String userId,
  }) async {
    final accessToken = await _getAccessToken();
    final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
    final password = base64Encode(utf8.encode('$_lipaNaMpesaShortcode$_lipaNaMpesaPasskey$timestamp'));

    final response = await http.post(
      Uri.parse('${_mpesaBaseUrl}stkpush/v1/processrequest'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'BusinessShortCode': _lipaNaMpesaShortcode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline', // or 'CustomerBuyGoodsOnline'
        'Amount': amount.toInt(), // M-Pesa API expects integer for amount
        'PartyA': phoneNumber, // Phone number initiating the transaction
        'PartyB': _lipaNaMpesaShortcode,
        'PhoneNumber': phoneNumber,
        'CallBackURL': _callbackUrl,
        'AccountReference': orderId, // Or any unique reference for the transaction
        'TransactionDesc': 'Payment for order $orderId',
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final transactionId = responseData['CheckoutRequestID'] as String;
      final resultCode = responseData['ResponseCode'] as String;

      if (resultCode == '0') {
        // STK Push initiated successfully, create a pending payment record
        final newPayment = Payment(
          id: const Uuid().v4(),
          userId: userId,
          orderId: orderId,
          amount: amount,
          transactionId: transactionId,
          status: PaymentStatus.pending,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _supabaseClient.from('payments').insert(newPayment.toJson());
        return newPayment;
      } else {
        throw Exception('M-Pesa STK Push failed: ${responseData['ResponseDescription']}');
      }
    } else {
      throw Exception('Failed to initiate M-Pesa STK Push: ${response.body}');
    }
  }

  @override
  Future<Payment> getPaymentStatus(String transactionId) async {
    final accessToken = await _getAccessToken();
    final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
    final password = base64Encode(utf8.encode('$_lipaNaMpesaShortcode$_lipaNaMpesaPasskey$timestamp'));

    final response = await http.post(
      Uri.parse('${_mpesaBaseUrl}stkpushquery/v1/query'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'BusinessShortCode': _lipaNaMpesaShortcode,
        'Password': password,
        'Timestamp': timestamp,
        'CheckoutRequestID': transactionId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final resultCode = responseData['ResultCode'] as String;

      if (resultCode == '0') {
        // Payment completed successfully
        await _supabaseClient.from('payments').update({'status': PaymentStatus.completed.toString().split('.').last, 'updated_at': DateTime.now().toIso8601String()}).eq('transaction_id', transactionId);
        final paymentData = await _supabaseClient.from('payments').select().eq('transaction_id', transactionId).single();
        return Payment.fromJson(paymentData);
      } else if (resultCode == '1037' || resultCode == '2001' || resultCode == '1032') {
        // Payment pending or user cancelled
        final paymentData = await _supabaseClient.from('payments').select().eq('transaction_id', transactionId).single();
        return Payment.fromJson(paymentData);
      } else {
        // Payment failed
        await _supabaseClient.from('payments').update({'status': PaymentStatus.failed.toString().split('.').last, 'updated_at': DateTime.now().toIso8601String()}).eq('transaction_id', transactionId);
        final paymentData = await _supabaseClient.from('payments').select().eq('transaction_id', transactionId).single();
        return Payment.fromJson(paymentData);
      }
    } else {
      throw Exception('Failed to get M-Pesa payment status: ${response.body}');
    }
  }
} 