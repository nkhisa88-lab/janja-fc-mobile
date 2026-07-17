class MatchModel {
  final int id;
  final String opponent;
  final String venue;
  final String matchDate;
  final String kickoffTime;
  final String status;

  const MatchModel({
    required this.id,
    required this.opponent,
    required this.venue,
    required this.matchDate,
    required this.kickoffTime,
    required this.status,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json["id"],
      opponent: json["opponent"],
      venue: json["venue"],
      matchDate: json["matchDate"],
      kickoffTime: json["kickoffTime"],
      status: json["status"],
    );
  }
}
