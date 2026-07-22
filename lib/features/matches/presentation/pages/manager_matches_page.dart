import 'package:fcjanja/features/matches/cubit/cubit/cancel_match_cubit.dart';
import 'package:fcjanja/features/matches/cubit/cubit/complete_match_cubit.dart';
import 'package:fcjanja/features/matches/cubit/cubit/match_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/repository/match_repository.dart';
import 'manager_matches_screen.dart';

class ManagerMatchesPage extends StatelessWidget {
  const ManagerMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MatchRepository(ApiService());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              MatchCubit(repository: repository, tokenStorage: TokenStorage())
                ..loadMatches(),
        ),
        BlocProvider(
          create: (_) => CompleteMatchCubit(
            repository: repository,
            tokenStorage: TokenStorage(),
          ),
        ),
        BlocProvider(
          create: (_) => CancelMatchCubit(
            repository: repository,
            tokenStorage: TokenStorage(),
          ),
        ),
      ],
      child: const ManagerMatchesScreen(),
    );
  }
}
