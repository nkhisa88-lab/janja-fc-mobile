part of 'respond_match_cubit.dart';

abstract class RespondMatchState extends Equatable {
  const RespondMatchState();

  @override
  List<Object?> get props => [];
}

class RespondMatchInitial extends RespondMatchState {
  const RespondMatchInitial();
}

class RespondMatchLoading extends RespondMatchState {
  final int matchId;

  const RespondMatchLoading(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class RespondMatchSuccess extends RespondMatchState {
  final int matchId;

  const RespondMatchSuccess(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class RespondMatchFailure extends RespondMatchState {
  final String message;

  const RespondMatchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
