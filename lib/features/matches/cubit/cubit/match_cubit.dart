import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/matches/data/models/match_model.dart';
import 'package:fcjanja/features/matches/data/repository/match_repository.dart';

part 'match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  final MatchRepository repository;
  final TokenStorage tokenStorage;

  MatchCubit({required this.repository, required this.tokenStorage})
    : super(const MatchInitial());

  Future<void> loadMatches() async {
    emit(const MatchLoading());

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const MatchFailure("User not logged in"));
        return;
      }

      final matches = await repository.getMatches(token);

      emit(MatchLoaded(matches));
    } catch (e) {
      emit(MatchFailure(e.toString()));
    }
  }
}
