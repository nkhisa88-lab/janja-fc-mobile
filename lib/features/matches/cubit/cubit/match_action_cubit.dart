import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/matches/data/repository/match_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'match_action_state.dart';

class MatchActionCubit extends Cubit<MatchActionState> {
  final MatchRepository repository;
  final TokenStorage tokenStorage;

  MatchActionCubit({
    required this.repository,
    required this.tokenStorage,
  }) : super(const MatchActionInitial());

  Future<void> completeMatch(int matchId) async {
    emit(MatchActionLoading(matchId));

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const MatchActionFailure("User not logged in"));
        return;
      }

      await repository.completeMatch(token, matchId);

      emit(const MatchActionSuccess());
    } catch (e) {
      emit(MatchActionFailure(e.toString()));
    }
  }

  Future<void> cancelMatch(int matchId) async {
    emit(MatchActionLoading(matchId));

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const MatchActionFailure("User not logged in"));
        return;
      }

      await repository.cancelMatch(token, matchId);

      emit(const MatchActionSuccess());
    } catch (e) {
      emit(MatchActionFailure(e.toString()));
    }
  }

  void reset() {
    emit(const MatchActionInitial());
  }
}
