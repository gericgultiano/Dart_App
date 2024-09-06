import '../models/user.dart';

class UserService {
  final List<User> _users = [
    User('user', 'user123'),
  ];

  bool authenticate(String username, String password) {
    return _users
        .any((user) => user.username == username && user.password == password);
  }
}
