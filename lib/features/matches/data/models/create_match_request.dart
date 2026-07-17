class CreateMatchRequest {
  final String opponent;
  final String venue;
  final String matchDate;
  final String kickoffTime;

  const CreateMatchRequest({
    required this.opponent,
    required this.venue,
    required this.matchDate,
    required this.kickoffTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "opponent": opponent,
      "venue": venue,
      "matchDate": matchDate,
      "kickoffTime": kickoffTime,
    };
  }
}
