import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lima_soko/core/services/supabase_service.dart';
import 'package:lima_soko/domain/entities/payment.dart';
import 'package:lima_soko/domain/repositories/mpesa_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

class MpesaServiceImpl implements MpesaService {
  final SupabaseClient _supabaseClient;
  final SupabaseService _supabaseService;

  MpesaServiceImpl(this._supabaseClient, this._supabaseService);

  // M-Pesa API configuration from environment variables
  String get _mpesaBaseUrl => dotenv.env['MPESA_BASE_URL'] ?? 'https://sandbox.safaricom.co.ke/';
  String get _consumerKey => dotenv.env['MPESA_CONSUMER_KEY'] ?? '';
  String get _consumerSecret => dotenv.env['MPESA_CONSUMER_SECRET'] ?? '';
  String get _lipaNaMpesaShortcode => dotenv.env['MPESA_SHORTCODE'] ?? '174379';
  String get _lipaNaMpesaPasskey => dotenv.env['MPESA_PASSKEY'] ?? '';
  String get _callbackUrl => dotenv.env['MPESA_CALLBACK_URL'] ?? '';

  Future<String> _getAccessToken() async {
    developer.log('Starting M-Pesa access token request', name: 'MpesaService');
    
    if (_consumerKey.isEmpty || _consumerSecret.isEmpty) {
      developer.log('M-Pesa credentials not configured', name: 'MpesaService', error: 'Missing credentials');
      throw Exception('M-Pesa credentials not configured. Please check your environment variables.');
    }

    try {
      final String credentials = base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'));
      developer.log('Sending access token request to M-Pesa', name: 'MpesaService');
      
      final response = await http.get(
        Uri.parse('${_mpesaBaseUrl}oauth/v1/generate?grant_type=client_credentials'),
        headers: {'Authorization': 'Basic $credentials'},
      );

      developer.log('Received response from M-Pesa auth endpoint', 
        name: 'MpesaService',
        error: 'Status code: ${response.statusCode}'
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log('Successfully obtained access token', name: 'MpesaService');
        return data['access_token'] as String;
      } else {
        developer.log('Failed to get access token', 
          name: 'MpesaService',
          error: 'Response: ${response.body}'
        );
        throw Exception('Failed to get M-Pesa access token: ${response.body}');
      }
    } catch (e) {
      developer.log('Error during access token request', 
        name: 'MpesaService',
        error: e.toString()
      );
      rethrow;
    }
  }

  @override
  Future<Payment> initiateStkPush({
    required String phoneNumber,
    required double amount,
    required String orderId,
    required String userId,
  }) async {
    developer.log('Initiating STK Push', 
      name: 'MpesaService',
      error: 'Phone: $phoneNumber, Amount: $amount, OrderId: $orderId'
    );

    try {
      final accessToken = await _getAccessToken();
      developer.log('Got access token, preparing STK Push request', name: 'MpesaService');

      final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
      final password = base64Encode(utf8.encode('$_lipaNaMpesaShortcode$_lipaNaMpesaPasskey$timestamp'));

      final requestBody = {
        'BusinessShortCode': _lipaNaMpesaShortcode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount.toInt(),
        'PartyA': phoneNumber,
        'PartyB': _lipaNaMpesaShortcode,
        'PhoneNumber': phoneNumber,
        'CallBackURL': _callbackUrl,
        'AccountReference': orderId,
        'TransactionDesc': 'Payment for order $orderId',
      };

      developer.log('Sending STK Push request to M-Pesa', 
        name: 'MpesaService',
        error: 'Request body: ${json.encode(requestBody)}'
      );

      final response = await http.post(
        Uri.parse('${_mpesaBaseUrl}mpesa/stkpush/v1/processrequest'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(requestBody),
      );

      developer.log('Received STK Push response', 
        name: 'MpesaService',
        error: 'Status code: ${response.statusCode}, Body: ${response.body}'
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final transactionId = responseData['CheckoutRequestID'] as String;
        final resultCode = responseData['ResponseCode'] as String;

        if (resultCode == '0') {
          developer.log('STK Push initiated successfully', 
            name: 'MpesaService',
            error: 'Transaction ID: $transactionId'
          );

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

          developer.log('Creating payment record in database', name: 'MpesaService');
          await _supabaseClient.from('payments').insert(newPayment.toJson());
          developer.log('Payment record created successfully', name: 'MpesaService');

          return newPayment;
        } else {
          developer.log('STK Push failed', 
            name: 'MpesaService',
            error: 'Response: ${responseData['ResponseDescription']}'
          );
          throw Exception('M-Pesa STK Push failed: ${responseData['ResponseDescription']}');
        }
      } else {
        developer.log('Failed to initiate STK Push', 
          name: 'MpesaService',
          error: 'Response: ${response.body}'
        );
        throw Exception('Failed to initiate M-Pesa STK Push: ${response.body}');
      }
    } catch (e) {
      developer.log('Error during STK Push', 
        name: 'MpesaService',
        error: e.toString()
      );
      rethrow;
    }
  }

  @override
  Future<Payment> getPaymentStatus(String transactionId) async {
    developer.log('Checking payment status', 
      name: 'MpesaService',
      error: 'Transaction ID: $transactionId'
    );

    try {
      final accessToken = await _getAccessToken();
      developer.log('Got access token for status check', name: 'MpesaService');

      final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
      final password = base64Encode(utf8.encode('$_lipaNaMpesaShortcode$_lipaNaMpesaPasskey$timestamp'));

      final requestBody = {
        'BusinessShortCode': _lipaNaMpesaShortcode,
        'Password': password,
        'Timestamp': timestamp,
        'CheckoutRequestID': transactionId,
      };

      developer.log('Sending payment status request', 
        name: 'MpesaService',
        error: 'Request body: ${json.encode(requestBody)}'
      );

      final response = await http.post(
        Uri.parse('${_mpesaBaseUrl}mpesa/stkpushquery/v1/query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(requestBody),
      );

      developer.log('Received payment status response', 
        name: 'MpesaService',
        error: 'Status code: ${response.statusCode}, Body: ${response.body}'
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final resultCode = responseData['ResultCode'] as String;

        developer.log('Processing payment status result', 
          name: 'MpesaService',
          error: 'Result code: $resultCode'
        );

        if (resultCode == '0') {
          developer.log('Payment completed successfully', name: 'MpesaService');
          await _supabaseClient.from('payments').update({
            'status': PaymentStatus.completed.toString().split('.').last,
            'updated_at': DateTime.now().toIso8601String()
          }).eq('transaction_id', transactionId);
          
          final paymentData = await _supabaseClient.from('payments')
            .select()
            .eq('transaction_id', transactionId)
            .single();
          
          return Payment.fromJson(paymentData);
        } else if (resultCode == '1037' || resultCode == '2001' || resultCode == '1032') {
          developer.log('Payment pending or user cancelled', 
            name: 'MpesaService',
            error: 'Result code: $resultCode'
          );
          final paymentData = await _supabaseClient.from('payments')
            .select()
            .eq('transaction_id', transactionId)
            .single();
          return Payment.fromJson(paymentData);
        } else {
          developer.log('Payment failed', 
            name: 'MpesaService',
            error: 'Result code: $resultCode'
          );
          await _supabaseClient.from('payments').update({
            'status': PaymentStatus.failed.toString().split('.').last,
            'updated_at': DateTime.now().toIso8601String()
          }).eq('transaction_id', transactionId);
          
          final paymentData = await _supabaseClient.from('payments')
            .select()
            .eq('transaction_id', transactionId)
            .single();
          return Payment.fromJson(paymentData);
        }
      } else {
        developer.log('Failed to get payment status', 
          name: 'MpesaService',
          error: 'Response: ${response.body}'
        );
        throw Exception('Failed to get M-Pesa payment status: ${response.body}');
      }
    } catch (e) {
      developer.log('Error during payment status check', 
        name: 'MpesaService',
        error: e.toString()
      );
      rethrow;
    }
  }
} 