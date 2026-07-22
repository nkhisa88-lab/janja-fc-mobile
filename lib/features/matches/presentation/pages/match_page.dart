import 'package:fcjanja/features/matches/cubit/cubit/match_cubit.dart';
import 'package:fcjanja/features/matches/presentation/pages/manager_matches_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/repository/match_repository.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchCubit(
        repository: MatchRepository(ApiService()),
        tokenStorage: TokenStorage(),
      )..loadMatches(),
      child: const ManagerMatchesPage(),
    );
  }
}
