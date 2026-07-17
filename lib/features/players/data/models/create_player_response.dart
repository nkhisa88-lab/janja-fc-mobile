class CreatePlayerResponse {
  final String activationCode;

  const CreatePlayerResponse({required this.activationCode});

  factory CreatePlayerResponse.fromJson(Map<String, dynamic> json) {
    return CreatePlayerResponse(activationCode: json["activationCode"]);
  }
}
