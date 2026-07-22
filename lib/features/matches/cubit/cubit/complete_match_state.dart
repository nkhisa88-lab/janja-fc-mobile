part of 'complete_match_cubit.dart';

abstract class CompleteMatchState extends Equatable {
  const CompleteMatchState();

  @override
  List<Object?> get props => [];
}

class CompleteMatchInitial extends CompleteMatchState {
  const CompleteMatchInitial();
}

class CompleteMatchLoading extends CompleteMatchState {
  final int matchId;

  const CompleteMatchLoading(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class CompleteMatchSuccess extends CompleteMatchState {
  const CompleteMatchSuccess();
}

class CompleteMatchFailure extends CompleteMatchState {
  final String message;

  const CompleteMatchFailure(this.message);

  @override
  List<Object?> get props => [message];
}