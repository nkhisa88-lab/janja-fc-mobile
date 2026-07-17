class MatchResponseRequest {
  final int matchId;
  final String status;

  MatchResponseRequest({required this.matchId, required this.status});

  Map<String, dynamic> toJson() {
    return {"matchId": matchId, "status": status};
  }
}
