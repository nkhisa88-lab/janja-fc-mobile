part of 'match_action_cubit.dart';


abstract class MatchActionState extends Equatable {
  const MatchActionState();

  @override
  List<Object?> get props => [];
}

class MatchActionInitial extends MatchActionState {
  const MatchActionInitial();
}

class MatchActionLoading extends MatchActionState {
  final int matchId;

  const MatchActionLoading(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class MatchActionSuccess extends MatchActionState {
  const MatchActionSuccess();
}

class MatchActionFailure extends MatchActionState {
  final String message;

  const MatchActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
