import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/players/data/models/create_player_request.dart';
import 'package:fcjanja/features/players/data/models/create_player_response.dart';
import 'package:fcjanja/features/players/data/repository/player_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_player_state.dart';

class CreatePlayerCubit extends Cubit<CreatePlayerState> {
  final PlayerRepository repository;
  final TokenStorage tokenStorage;

  CreatePlayerCubit({required this.repository, required this.tokenStorage})
    : super(const CreatePlayerInitial());

  Future<void> createPlayer({
    required String fullName,
    required String phoneNumber,
  }) async {
    emit(const CreatePlayerLoading());

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const CreatePlayerFailure("User not logged in"));
        return;
      }

      final response = await repository.createPlayer(
        token,
        CreatePlayerRequest(fullName: fullName, phoneNumber: phoneNumber),
      );

      emit(CreatePlayerSuccess(response));
    } catch (e) {
      emit(CreatePlayerFailure(e.toString()));
    }
  }
}
