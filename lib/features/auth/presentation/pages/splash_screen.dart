import 'dart:async';

import 'package:fcjanja/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:fcjanja/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/security/jwt_service.dart';
import '../../../../core/storage/token_storage.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthCubit authCubit;

  @override
  void initState() {
    super.initState();

    authCubit = AuthCubit(
      tokenStorage: TokenStorage(),
      jwtService: JwtService(),
    );

    _startAuthenticationCheck();
  }

  Future<void> _startAuthenticationCheck() async {
    await Future.delayed(const Duration(milliseconds: 2400));

    if (!mounted) return;

    await authCubit.checkAuthentication();
  }

  @override
  void dispose() {
    authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authCubit,
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
                builder: (_) => const DashboardPage(isAdmin: false),
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
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final logoSize = width < 600 ? 90.0 : 130.0;

            final titleSize = width < 600 ? 28.0 : 38.0;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3),
                      ),
                      child: Icon(Icons.sports_soccer, size: logoSize * 0.55),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Janja FC",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Football Club Management System",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 40),

                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Checking authentication...",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
