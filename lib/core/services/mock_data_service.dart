import 'package:lima_soko/domain/entities/product.dart';

class MockDataService {
  static final List<Map<String, dynamic>> mockCategories = [
    {
      'id': '1',
      'name': 'Vegetables',
      'description': 'Fresh vegetables from local farmers',
    },
    {
      'id': '2',
      'name': 'Fruits',
      'description': 'Seasonal and exotic fruits',
    },
    {
      'id': '3',
      'name': 'Grains',
      'description': 'Various types of grains and cereals',
    },
    {
      'id': '4',
      'name': 'Dairy',
      'description': 'Fresh dairy products',
    },
  ];

  static final List<Map<String, dynamic>> mockProducts = [
    {
      'id': '1',
      'name': 'Fresh Tomatoes',
      'description': 'Organic tomatoes grown locally',
      'price': 2.99,
      'category_id': '1',
      'seller_id': 'mock_farmer_1',
      'stock_quantity': 100,
      'images': [
        'https://images.unsplash.com/photo-1546094097-246e1c693f3b?w=500',
      ],
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'name': 'Organic Spinach',
      'description': 'Fresh organic spinach leaves',
      'price': 3.49,
      'category_id': '1',
      'seller_id': 'mock_farmer_1',
      'stock_quantity': 50,
      'images': [
        'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500',
      ],
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    },
    {
      'id': '3',
      'name': 'Red Apples',
      'description': 'Sweet and crispy red apples',
      'price': 4.99,
      'category_id': '2',
      'seller_id': 'mock_farmer_2',
      'stock_quantity': 75,
      'images': [
        'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=500',
      ],
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    },
    {
      'id': '4',
      'name': 'Organic Quinoa',
      'description': 'Premium organic quinoa grains',
      'price': 8.99,
      'category_id': '3',
      'seller_id': 'mock_farmer_3',
      'stock_quantity': 200,
      'images': [
        'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500',
      ],
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    },
    {
      'id': '5',
      'name': 'Fresh Milk',
      'description': 'Farm-fresh whole milk',
      'price': 3.99,
      'category_id': '4',
      'seller_id': 'mock_farmer_4',
      'stock_quantity': 150,
      'images': [
        'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500',
      ],
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    },
  ];

  static List<Product> getMockProducts() {
    return mockProducts.map((product) => Product.fromJson(product)).toList();
  }

  static List<Map<String, dynamic>> getMockCategories() {
    return mockCategories;
  }

  static List<Product> getProductsByCategory(String categoryId) {
    return mockProducts
        .where((product) => product['category_id'] == categoryId)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  static List<Product> searchProducts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return mockProducts
        .where((product) =>
            product['name'].toLowerCase().contains(lowercaseQuery) ||
            product['description'].toLowerCase().contains(lowercaseQuery))
        .map((product) => Product.fromJson(product))
        .toList();
  }
} 