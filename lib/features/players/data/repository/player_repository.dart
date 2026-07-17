import 'package:fcjanja/features/players/data/models/create_player_response.dart';

import '../../../../core/network/api_service.dart';
import '../models/create_player_request.dart';

class PlayerRepository {
  final ApiService apiService;

  PlayerRepository(this.apiService);

  Future<CreatePlayerResponse> createPlayer(
    String token,
    CreatePlayerRequest request,
  ) {
    return apiService.createPlayer(token, request);
  }
}
