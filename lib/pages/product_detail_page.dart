import 'package:flutter/material.dart';
import '../domain/entities/product.dart'; // Import Product entity
import '../core/utils/color_converter.dart'; // Import color converter

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

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
        title: Text(product.name), // Use product name for title
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
              product.images.isNotEmpty ? product.images[0] : 'https://via.placeholder.com/400x300', // Use actual product image
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 300,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey)),
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
                      Expanded(
                        child: Text(
                          product.name, // Use actual product title
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                          maxLines: 2, // Limit to 2 lines
                        ),
                      ),
                      Text(
                        '\${product.price.toStringAsFixed(2)} per lb', // Use actual price
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Star Rating and Reviews
                  Row(
                    children: [
                      ...List.generate(product.rating.floor(), (index) => Icon(Icons.star, color: Colors.amber, size: 18)),
                      if (product.rating - product.rating.floor() > 0) Icon(Icons.star_half, color: Colors.amber, size: 18),
                      ...List.generate(5 - product.rating.ceil(), (index) => Icon(Icons.star_border, color: Colors.amber, size: 18)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '\${product.rating} (\${product.reviews} reviews)',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                          maxLines: 1, // Limit to 1 line
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Product Description
                  Text(
                    product.description, // Use actual description
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
                      ...product.varieties.map((colorString) =>
                         Padding(
                           padding: const EdgeInsets.only(right: 8.0),
                           child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getColorFromString(colorString), // Use global function
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                                                 ),
                         ),
                      ).toList(),
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
                      value: product.weights.isNotEmpty ? product.weights[0] : null, // Use actual product weight
                      icon: Icon(Icons.arrow_drop_down),
                      underline: SizedBox(), // Remove underline
                      onChanged: (String? newValue) {
                        // TODO: Implement weight selection logic
                      },
                      items: product.weights.map<DropdownMenuItem<String>>((String value) {
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

  Color getColorFromString(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'brown':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
} 