import 'package:fcjanja/features/matches/cubit/cubit/match_cubit.dart';
import 'package:fcjanja/features/response/cubit/cubit/respond_match_cubit.dart';
import 'package:fcjanja/features/response/presentation/player_matches_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../../../core/storage/token_storage.dart';
import '../../matches/data/repository/match_repository.dart';
import '../data/repository/response_repository.dart';

class PlayerMatchesPage extends StatelessWidget {
  const PlayerMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final tokenStorage = TokenStorage();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MatchCubit(
            repository: MatchRepository(apiService),
            tokenStorage: tokenStorage,
          )..loadMatches(),
        ),

        BlocProvider(
          create: (_) => RespondMatchCubit(
            repository: ResponseRepository(apiService),
            tokenStorage: tokenStorage,
          ),
        ),
      ],
      child: const PlayerMatchesScreen(),
    );
  }
}
