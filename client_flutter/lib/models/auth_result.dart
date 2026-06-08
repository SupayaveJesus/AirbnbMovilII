import 'user_model.dart';

class AuthResult {
  const AuthResult({
    required this.user,
    required this.token,
    required this.message,
  });

  final UserModel user;
  final String token;
  final String message;
}
