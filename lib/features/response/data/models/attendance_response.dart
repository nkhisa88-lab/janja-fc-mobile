class AttendanceResponse {
  final int available;
  final int unavailable;
  final int pending;

  AttendanceResponse({
    required this.available,
    required this.unavailable,
    required this.pending,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      available: json["available"],
      unavailable: json["unavailable"],
      pending: json["pending"],
    );
  }
}
