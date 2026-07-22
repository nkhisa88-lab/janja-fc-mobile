import 'package:fcjanja/features/matches/cubit/cubit/create_match_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/repository/match_repository.dart';
import 'create_match_screen.dart';

class CreateMatchPage extends StatelessWidget {
  const CreateMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateMatchCubit(
        repository: MatchRepository(ApiService()),
        tokenStorage: TokenStorage(),
      ),
      child: const CreateMatchScreen(),
    );
  }
}
