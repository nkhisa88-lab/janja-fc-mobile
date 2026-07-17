class SetPasswordRequest {
  final String password;
  final String confirmPassword;

  const SetPasswordRequest({
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {"password": password, "confirmPassword": confirmPassword};
  }
}
