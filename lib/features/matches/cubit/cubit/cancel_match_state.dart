part of 'cancel_match_cubit.dart';

abstract class CancelMatchState extends Equatable {
  const CancelMatchState();

  @override
  List<Object?> get props => [];
}

class CancelMatchInitial extends CancelMatchState {
  const CancelMatchInitial();
}

class CancelMatchLoading extends CancelMatchState {
  final int matchId;

  const CancelMatchLoading(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class CancelMatchSuccess extends CancelMatchState {
  const CancelMatchSuccess();
}

class CancelMatchFailure extends CancelMatchState {
  final String message;

  const CancelMatchFailure(this.message);

  @override
  List<Object?> get props => [message];
}