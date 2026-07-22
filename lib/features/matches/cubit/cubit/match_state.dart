part of 'match_cubit.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object?> get props => [];
}

class MatchInitial extends MatchState {
  const MatchInitial();
}

class MatchLoading extends MatchState {
  const MatchLoading();
}

class MatchLoaded extends MatchState {
  final List<MatchModel> matches;

  const MatchLoaded(this.matches);

  @override
  List<Object?> get props => [matches];
}

class MatchFailure extends MatchState {
  final String message;

  const MatchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
