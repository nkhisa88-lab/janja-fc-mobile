part of 'create_match_cubit.dart';

abstract class CreateMatchState extends Equatable {
  const CreateMatchState();

  @override
  List<Object?> get props => [];
}

class CreateMatchInitial extends CreateMatchState {
  const CreateMatchInitial();
}

class CreateMatchLoading extends CreateMatchState {
  const CreateMatchLoading();
}

class CreateMatchSuccess extends CreateMatchState {
  const CreateMatchSuccess();
}

class CreateMatchFailure extends CreateMatchState {
  final String message;

  const CreateMatchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
