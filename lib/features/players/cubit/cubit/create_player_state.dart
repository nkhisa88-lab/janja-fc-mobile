part of 'create_player_cubit.dart';

abstract class CreatePlayerState extends Equatable {
  const CreatePlayerState();

  @override
  List<Object?> get props => [];
}

class CreatePlayerInitial extends CreatePlayerState {
  const CreatePlayerInitial();
}

class CreatePlayerLoading extends CreatePlayerState {
  const CreatePlayerLoading();
}

class CreatePlayerSuccess extends CreatePlayerState {
  final CreatePlayerResponse response;

  const CreatePlayerSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CreatePlayerFailure extends CreatePlayerState {
  final String message;

  const CreatePlayerFailure(this.message);

  @override
  List<Object?> get props => [message];
}
