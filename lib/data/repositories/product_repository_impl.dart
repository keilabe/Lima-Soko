import 'package:lima_soko/domain/entities/product.dart';
import 'package:lima_soko/domain/repositories/product_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepositoryImpl implements ProductRepository {
  final SupabaseClient _supabaseClient;

  ProductRepositoryImpl(this._supabaseClient);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final List<Map<String, dynamic>> productData = await _supabaseClient.from('products').select();
      return productData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    final response = await _supabaseClient.from('products').select().eq('id', id).single();
    return Product.fromJson(response);
  }

  @override
  Future<void> addProduct(Product product) async {
    await _supabaseClient.from('products').insert(product.toJson());
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _supabaseClient.from('products').update(product.toJson()).eq('id', product.id);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _supabaseClient.from('products').delete().eq('id', id);
  }
} 