import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/security/jwt_service.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final TokenStorage tokenStorage;
  final JwtService jwtService;

  AuthCubit({required this.tokenStorage, required this.jwtService})
    : super(const AuthInitial());

  Future<void> checkAuthentication() async {
    emit(const AuthLoading());

    try {
      final token = await tokenStorage.getToken();

      if (token == null || token.isEmpty) {
        emit(const Unauthenticated());
        return;
      }

      final isAdmin = jwtService.isAdmin(token);

      if (isAdmin) {
        emit(const AuthenticatedAdmin());
      } else {
        emit(const AuthenticatedPlayer());
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }

  Future<void> logout() async {
    await tokenStorage.deleteToken();
    emit(const Unauthenticated());
  }
}
