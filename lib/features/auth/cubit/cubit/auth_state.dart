part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthenticatedAdmin extends AuthState {
  const AuthenticatedAdmin();
}

class AuthenticatedPlayer extends AuthState {
  const AuthenticatedPlayer();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}
