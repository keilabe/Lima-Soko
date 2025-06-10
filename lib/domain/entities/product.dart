class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String sellerId;
  final int stockQuantity;
  final List<String> images;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double rating;
  final int reviews;
  final List<String> varieties;
  final List<String> weights;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.sellerId,
    required this.stockQuantity,
    required this.images,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.rating = 0.0,
    this.reviews = 0,
    this.varieties = const [],
    this.weights = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'],
      sellerId: json['seller_id'],
      stockQuantity: json['stock_quantity'],
      images: List<String>.from(json['images'] ?? []),
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] ?? 0,
      varieties: List<String>.from(json['varieties'] ?? []),
      weights: List<String>.from(json['weights'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'seller_id': sellerId,
      'stock_quantity': stockQuantity,
      'images': images,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'rating': rating,
      'reviews': reviews,
      'varieties': varieties,
      'weights': weights,
    };
  }
} 