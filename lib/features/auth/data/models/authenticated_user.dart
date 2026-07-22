import 'package:equatable/equatable.dart';

class AuthenticatedUser extends Equatable {
  final String token;
  final bool mustSetPassword;
  final bool isAdmin;

  const AuthenticatedUser({
    required this.token,
    required this.mustSetPassword,
    required this.isAdmin,
  });

  @override
  List<Object?> get props => [token, mustSetPassword, isAdmin];
}
