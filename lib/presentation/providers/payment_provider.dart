import 'package:flutter/foundation.dart';
import 'package:lima_soko/core/services/supabase_service.dart';
import 'package:lima_soko/domain/entities/payment.dart';
import 'package:lima_soko/domain/repositories/mpesa_service.dart';

class PaymentProvider with ChangeNotifier {
  final MpesaService _mpesaService;
  final SupabaseService _supabaseService;

  PaymentProvider({
    required MpesaService mpesaService,
    required SupabaseService supabaseService,
  })
      : _mpesaService = mpesaService,
        _supabaseService = supabaseService;

  bool _isLoading = false;
  String? _errorMessage;
  Payment? _currentPayment;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Payment? get currentPayment => _currentPayment;

  Future<void> initiatePayment({
    required String phoneNumber,
    required double amount,
    required String orderId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_supabaseService.userId == null) {
        throw Exception('User not logged in.');
      }
      _currentPayment = await _mpesaService.initiateStkPush(
        phoneNumber: phoneNumber,
        amount: amount,
        orderId: orderId,
        userId: _supabaseService.userId!,
      );
      // Optionally, poll for payment status or wait for callback
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkPaymentStatus(String transactionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentPayment = await _mpesaService.getPaymentStatus(transactionId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 