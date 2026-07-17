import 'package:fcjanja/features/matches/data/models/create_match_request.dart';

import '../models/match_model.dart';
import '../../../../core/network/api_service.dart';

class MatchRepository {
  final ApiService apiService;

  MatchRepository(this.apiService);

  Future<List<MatchModel>> getMatches(String token) {
    return apiService.getMatches(token);
  }

  Future<void> createMatch(String token, CreateMatchRequest request) {
    return apiService.createMatch(token, request);
  }

  Future<void> completeMatch(String token, int matchId) {
    return apiService.completeMatch(token, matchId);
  }

  Future<void> cancelMatch(String token, int matchId) {
    return apiService.cancelMatch(token, matchId);
  }
}
