import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Your Cart'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder for Cart Items List
              Expanded(
                child: ListView(
                  children: [
                    // Example Cart Item 1 (Fresh Tomatoes)
                    CartItem(
                      imageUrl: 'https://via.placeholder.com/100', // Replace with actual image
                      title: 'Fresh Tomatoes',
                      weightType: 'Weight: Type: Organic',
                      price: '\$3',
                    ),
                    SizedBox(height: 16),
                    // Example Cart Item 2 (Green Lettuce)
                    CartItem(
                      imageUrl: 'https://via.placeholder.com/100', // Replace with actual image
                      title: 'Green Lettuce',
                      weightType: 'Weight: Type: Organic',
                      price: '\$2',
                    ),                  
                    SizedBox(height: 16),
                    // Example Cart Item 3 (Cucumbers)
                     CartItem(
                      imageUrl: 'https://via.placeholder.com/100', // Replace with actual image
                      title: 'Cucumbers',
                      weightType: 'Weight: Type: Fresh',
                      price: '\$4',
                    ),
                     SizedBox(height: 16),
                    // Add more items as needed
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$9', // Placeholder value
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Checkout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement checkout logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.amber[300] // Example button color
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
        // BottomNavigationBar is handled in HomePage, so no need to include here
      ),
    );
  }
}

// Helper widget for individual cart items
class CartItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String weightType;
  final String price;

  const CartItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.weightType,
    required this.price,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int _quantity = 1; // Default quantity

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item Image
        Image.network(
          widget.imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 80,
            height: 80,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, size: 40, color: Colors.grey[600]),
          ),
        ),
        SizedBox(width: 16),
        // Item Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                widget.weightType,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  // Quantity Selector
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: _decrementQuantity,
                  ),
                  Text('$_quantity'),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: 20),
                    onPressed: _incrementQuantity,
                  ),
                  // Trash Icon (appears next to quantity in image)
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 20),
                    onPressed: () {
                      // TODO: Implement item removal
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        // Item Price
        Text(
          widget.price,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
} 