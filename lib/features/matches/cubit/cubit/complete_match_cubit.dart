import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/matches/data/repository/match_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'complete_match_state.dart';

class CompleteMatchCubit extends Cubit<CompleteMatchState> {
  final MatchRepository repository;
  final TokenStorage tokenStorage;

  CompleteMatchCubit({required this.repository, required this.tokenStorage})
    : super(const CompleteMatchInitial());

  Future<void> completeMatch(int matchId) async {
    emit(CompleteMatchLoading(matchId));

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const CompleteMatchFailure("User not logged in"));
        return;
      }

      await repository.completeMatch(token, matchId);

      emit(const CompleteMatchSuccess());
      emit(const CompleteMatchInitial());
    } catch (e) {
      emit(CompleteMatchFailure(e.toString()));
    }
  }
}
