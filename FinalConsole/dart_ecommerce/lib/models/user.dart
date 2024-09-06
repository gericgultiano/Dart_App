// models/user.dart
class User {
  final String username;
  final String password; // In a real application, passwords should be hashed

  User(this.username, this.password);
}
