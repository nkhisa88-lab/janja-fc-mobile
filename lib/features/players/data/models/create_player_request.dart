class CreatePlayerRequest {
  final String fullName;
  final String phoneNumber;

  const CreatePlayerRequest({
    required this.fullName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {"fullName": fullName, "phoneNumber": phoneNumber};
  }
}
