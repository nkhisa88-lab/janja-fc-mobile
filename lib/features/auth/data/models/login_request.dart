class LoginRequest {
  final String phoneNumber;
  final String secret;

  const LoginRequest({required this.phoneNumber, required this.secret});

  Map<String, dynamic> toJson() {
    return {"phoneNumber": phoneNumber, "secret": secret};
  }
}
