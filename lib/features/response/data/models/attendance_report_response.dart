class AttendanceReportResponse {
  final String opponent;
  final String matchDate;

  final List<String> available;
  final List<String> unavailable;
  final List<String> pending;

  AttendanceReportResponse({
    required this.opponent,
    required this.matchDate,
    required this.available,
    required this.unavailable,
    required this.pending,
  });

  factory AttendanceReportResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceReportResponse(
      opponent: json["opponent"],
      matchDate: json["matchDate"],
      available: List<String>.from(json["available"]),
      unavailable: List<String>.from(json["unavailable"]),
      pending: List<String>.from(json["pending"]),
    );
  }
}
