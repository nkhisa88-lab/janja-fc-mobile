import 'package:fcjanja/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/security/jwt_service.dart';
import '../../../../core/storage/token_storage.dart';
import 'dashboard_screen.dart';

class DashboardPage extends StatelessWidget {
  final bool isAdmin;

  const DashboardPage({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthCubit(tokenStorage: TokenStorage(), jwtService: JwtService()),
      child: DashboardScreen(isAdmin: isAdmin),
    );
  }
}
