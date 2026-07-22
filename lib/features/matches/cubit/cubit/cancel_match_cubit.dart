import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/matches/data/repository/match_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cancel_match_state.dart';

class CancelMatchCubit extends Cubit<CancelMatchState> {
  final MatchRepository repository;
  final TokenStorage tokenStorage;

  CancelMatchCubit({required this.repository, required this.tokenStorage})
    : super(const CancelMatchInitial());

  Future<void> cancelMatch(int matchId) async {
    emit(CancelMatchLoading(matchId));

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const CancelMatchFailure("User not logged in"));
        return;
      }

      await repository.cancelMatch(token, matchId);

      emit(const CancelMatchSuccess());
      emit(const CancelMatchInitial());
    } catch (e) {
      emit(CancelMatchFailure(e.toString()));
    }
  }
}
