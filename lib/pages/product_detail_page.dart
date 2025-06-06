import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Product detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border), // Heart icon
            onPressed: () {
              // TODO: Implement favorite logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.network(
              'https://via.placeholder.com/400x300', // Replace with actual product image
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 300,
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, size: 80, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Title
                      Text(
                        'Farm Fresh Tomatoes', // Replace with actual product title
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      // Product Price
                      Text(
                        '\$3 per lb', // Replace with actual price
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Star Rating and Reviews
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Icon(Icons.star_half, color: Colors.amber, size: 18),
                      Icon(Icons.star_border, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text('4.5 (29 reviews)', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Product Description
                  Text(
                    'These tomatoes are vine-ripened and bursting with flavor.', // Replace with actual description
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                  // 'more' button placeholder
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement show more description
                      },
                      child: Text('more'),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Varieties
                  Text(
                    'Varieties',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Placeholder for variety circles
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 8),
                       Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 8),
                       Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Weight
                  Text(
                    'Weight',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: '1', // Placeholder value
                      icon: Icon(Icons.arrow_drop_down),
                      underline: SizedBox(), // Remove underline
                      onChanged: (String? newValue) {
                        // TODO: Implement weight selection logic
                      },
                      items: <String>['1', '2', '3', '4'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement add to cart logic
                      },
                      icon: Icon(Icons.shopping_cart_outlined, color: Colors.black87), // Cart icon
                      label: Text(
                        'Add to cart',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.amber[300] // Example button color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // BottomNavigationBar is handled in HomePage, so no need to include here
    );
  }
} 