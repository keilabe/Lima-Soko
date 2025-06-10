import 'package:uuid/uuid.dart';

enum PaymentStatus {
  pending,
  completed,
  failed,
}

class Payment {
  final String id;
  final String userId;
  final String? orderId;
  final double amount;
  final String transactionId;
  final PaymentStatus status;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.userId,
    this.orderId,
    required this.amount,
    required this.transactionId,
    required this.status,
    this.paymentMethod = 'M-Pesa',
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      orderId: json['order_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      transactionId: json['transaction_id'] as String,
      status: PaymentStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'] as String),
      paymentMethod: json['payment_method'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_id': orderId,
      'amount': amount,
      'transaction_id': transactionId,
      'status': status.toString().split('.').last,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Payment copyWith({
    String? id,
    String? userId,
    String? orderId,
    double? amount,
    String? transactionId,
    PaymentStatus? status,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 