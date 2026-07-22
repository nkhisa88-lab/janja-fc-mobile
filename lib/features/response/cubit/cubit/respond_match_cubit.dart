import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/response/data/models/match_response_request.dart';
import 'package:fcjanja/features/response/data/repository/response_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'respond_match_state.dart';

class RespondMatchCubit extends Cubit<RespondMatchState> {
  final ResponseRepository repository;
  final TokenStorage tokenStorage;

  RespondMatchCubit({required this.repository, required this.tokenStorage})
    : super(const RespondMatchInitial());

  Future<void> respond({required int matchId, required String status}) async {
    emit(RespondMatchLoading(matchId));

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const RespondMatchFailure("User not logged in"));
        return;
      }

      await repository.respondToMatch(
        token,
        MatchResponseRequest(matchId: matchId, status: status),
      );

      emit(RespondMatchSuccess(matchId));
      emit(const RespondMatchInitial());
    } catch (e) {
      emit(RespondMatchFailure(e.toString()));
    }
  }

  void reset() {
    emit(const RespondMatchInitial());
  }
}
