import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lima_soko/presentation/providers/cart_provider.dart';
import 'package:lima_soko/presentation/providers/payment_provider.dart';
import 'package:lima_soko/presentation/providers/user_provider.dart';
import 'package:lima_soko/domain/entities/payment.dart';
import 'package:lima_soko/core/services/supabase_service.dart';
import 'package:lima_soko/presentation/providers/order_provider.dart';
import 'package:lima_soko/domain/entities/order.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  late final SupabaseService _supabaseService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSupabase();
  }

  Future<void> _initializeSupabase() async {
    _supabaseService = await SupabaseService.getInstance();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<bool> _verifyUserSession() async {
    if (!_isInitialized) return false;
    final session = _supabaseService.client.auth.currentSession;
    return session != null;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Consumer2<CartProvider, PaymentProvider>(
        builder: (context, cartProvider, paymentProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty. Add items to checkout.'),
            );
          }

          final cartItemsList = cartProvider.items.values.toList();
          final userProvider = Provider.of<UserProvider>(context, listen: false);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (context, index) {
                      final item = cartItemsList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.network(
                                item.product.images.isNotEmpty
                                    ? item.product.images[0]
                                    : 'https://via.placeholder.com/50',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text('Quantity: ${item.quantity}'),
                                    Text('Price: KSh ${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'KSh ${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'M-Pesa Phone Number',
                    hintText: 'e.g., 254712345678',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: paymentProvider.isLoading
                        ? null
                        : () async {
                            if (_phoneNumberController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter your M-Pesa phone number.')),
                              );
                              return;
                            }

                            final isAuthenticated = await _verifyUserSession();
                            if (!isAuthenticated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Your session has expired. Please log in again.'),
                                  action: SnackBarAction(
                                    label: 'Login',
                                    onPressed: () {
                                      Navigator.of(context).pushReplacementNamed('/login');
                                    },
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                              final userId = userProvider.currentUser?.id;

                              if (userId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User not logged in or ID not found.')),
                                );
                                return;
                              }

                              final newOrder = await orderProvider.createOrder(
                                userId: userId,
                                items: cartProvider.items.values.toList(),
                                totalAmount: cartProvider.totalAmount,
                              );

                              if (newOrder == null || newOrder.id == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to create order.')),
                                );
                                return;
                              }

                              await paymentProvider.initiatePayment(
                                phoneNumber: _phoneNumberController.text,
                                amount: cartProvider.totalAmount,
                                orderId: newOrder.id!,
                              );

                              if (paymentProvider.currentPayment?.status == PaymentStatus.pending) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('M-Pesa STK Push initiated. Check your phone.')),
                                );
                                cartProvider.clearCart();
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              } else if (paymentProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(paymentProvider.errorMessage!),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Payment processing failed.')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Payment error: ${e.toString()}')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                    ),
                    child: paymentProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Proceed to Payment',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 