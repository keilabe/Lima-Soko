import 'package:lima_soko/domain/entities/payment.dart';

abstract class MpesaService {
  Future<Payment> initiateStkPush({
    required String phoneNumber,
    required double amount,
    required String orderId,
    required String userId,
  });
  
  Future<Payment> getPaymentStatus(String transactionId);
} 