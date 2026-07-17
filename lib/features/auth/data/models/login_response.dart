class LoginResponse {
  final bool success;
  final bool mustSetPassword;
  final String? token;

  const LoginResponse({
    required this.success,
    required this.mustSetPassword,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"],
      mustSetPassword: json["mustSetPassword"],
      token: json["token"],
    );
  }
}
