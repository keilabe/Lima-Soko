import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient client;

  SupabaseService._();

  static Future<SupabaseService> getInstance() async {
    if (_instance == null) {
      _instance = SupabaseService._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  Future<void> _initialize() async {
    try {
      await dotenv.load();
      
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception('Missing Supabase credentials in .env file');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      client = Supabase.instance.client;
    } catch (e) {
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  String? get userId => client.auth.currentUser?.id;

  Future<void> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<T?> querySingle<T>({
    required String table,
    required String column,
    required String operator,
    required dynamic value,
  }) async {
    try {
      final response = await client
          .from(table)
          .select()
          .filter(column, operator, value)
          .single();
      return response as T?;
    } catch (e) {
      throw Exception('Query failed: $e');
    }
  }

  Future<List<T>> queryList<T>({
    required String table,
    String? column,
    String? operator,
    dynamic value,
  }) async {
    try {
      var query = client.from(table).select();
      if (column != null && operator != null && value != null) {
        query = query.filter(column, operator, value);
      }
      final response = await query;
      return response as List<T>;
    } catch (e) {
      throw Exception('Query failed: $e');
    }
  }

  Future<void> insert<T>({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      await client.from(table).insert(data);
    } catch (e) {
      throw Exception('Insert failed: $e');
    }
  }

  Future<void> update<T>({
    required String table,
    required String column,
    required String operator,
    required dynamic value,
    required Map<String, dynamic> data,
  }) async {
    try {
      await client
          .from(table)
          .update(data)
          .filter(column, operator, value);
    } catch (e) {
      throw Exception('Update failed: $e');
    }
  }

  Future<void> delete<T>({
    required String table,
    required String column,
    required String operator,
    required dynamic value,
  }) async {
    try {
      await client
          .from(table)
          .delete()
          .filter(column, operator, value);
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }

  Future<User> signUp(String email, String password, [Map<String, dynamic>? data]) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      
      if (response.user == null) {
        throw Exception('Failed to create user account');
      }
      return response.user!;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }
} 