import 'package:fcjanja/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:fcjanja/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/security/jwt_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import 'login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthCubit(tokenStorage: TokenStorage(), jwtService: JwtService())
            ..checkAuthentication(),

      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedAdmin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DashboardPage(isAdmin: true),
              ),
            );
          }

          if (state is AuthenticatedPlayer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DashboardScreen(isAdmin: false),
              ),
            );
          }

          if (state is Unauthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },

        child: const _SplashBody(),
      ),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
