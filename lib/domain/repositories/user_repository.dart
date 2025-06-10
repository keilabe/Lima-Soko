import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> getUser(String id);
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
  Future<User?> getCurrentUser();
  Future<void> signOut();
} 