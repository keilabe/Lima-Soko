import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient _supabaseClient;

  UserRepositoryImpl(this._supabaseClient);

  @override
  Future<domain.User?> getUser(String id) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', id)
          .single();
      return domain.User.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<domain.User> createUser(domain.User user) async {
    final response = await _supabaseClient
        .from('profiles')
        .insert(user.toJson())
        .select()
        .single();
    return domain.User.fromJson(response);
  }

  @override
  Future<domain.User> updateUser(domain.User user) async {
    final response = await _supabaseClient
        .from('profiles')
        .update(user.toJson())
        .eq('id', user.id)
        .select()
        .single();
    return domain.User.fromJson(response);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _supabaseClient.from('profiles').delete().eq('id', id);
  }

  @override
  Future<domain.User?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;
      return getUser(user.id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
} 