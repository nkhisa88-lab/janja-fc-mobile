import 'package:fcjanja/features/auth/cubit/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/security/jwt_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/repository/auth_repository.dart';
import 'login_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        repository: AuthRepository(ApiService()),
        tokenStorage: TokenStorage(),
        jwtService: JwtService(),
      ),
      child: const LoginScreen(),
    );
  }
}
