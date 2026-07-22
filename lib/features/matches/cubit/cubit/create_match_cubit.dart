import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/matches/data/models/create_match_request.dart';
import 'package:fcjanja/features/matches/data/repository/match_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_match_state.dart';

class CreateMatchCubit extends Cubit<CreateMatchState> {
  final MatchRepository repository;
  final TokenStorage tokenStorage;

  CreateMatchCubit({required this.repository, required this.tokenStorage})
    : super(const CreateMatchInitial());

  Future<void> createMatch({
    required String opponent,
    required String venue,
    required String matchDate,
    required String kickoffTime,
  }) async {
    emit(const CreateMatchLoading());

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const CreateMatchFailure("User not logged in"));
        return;
      }

      await repository.createMatch(
        token,
        CreateMatchRequest(
          opponent: opponent,
          venue: venue,
          matchDate: matchDate,
          kickoffTime: kickoffTime,
        ),
      );

      emit(const CreateMatchSuccess());
    } catch (e) {
      emit(CreateMatchFailure(e.toString()));
    }
  }
}
