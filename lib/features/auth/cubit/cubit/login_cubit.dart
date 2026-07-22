import 'package:fcjanja/core/security/jwt_service.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/auth/cubit/cubit/login_state.dart';
import 'package:fcjanja/features/auth/data/models/authenticated_user.dart';
import 'package:fcjanja/features/auth/data/models/login_request.dart';
import 'package:fcjanja/features/auth/data/models/login_response.dart';
import 'package:fcjanja/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;
  final TokenStorage tokenStorage;
  final JwtService jwtService;

  LoginCubit({
    required this.repository,
    required this.tokenStorage,
    required this.jwtService,
  }) : super(LoginInitial());

  Future<void> login({
    required String phoneNumber,
    required String secret,
  }) async {
    emit(LoginLoading());

    try {
      final LoginResponse response = await repository.login(
        LoginRequest(phoneNumber: phoneNumber, secret: secret),
      );

      if (!response.mustSetPassword) {
        await tokenStorage.saveToken(response.token!);
      }

      final authenticatedUser = AuthenticatedUser(
        token: response.token!,
        mustSetPassword: response.mustSetPassword,
        isAdmin: response.mustSetPassword
            ? false
            : jwtService.isAdmin(response.token!),
      );

      emit(LoginSuccess(authenticatedUser));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
