import 'package:fcjanja/features/players/cubit/cubit/create_player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/repository/player_repository.dart';
import 'create_player_screen.dart';

class CreatePlayerPage extends StatelessWidget {
  const CreatePlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreatePlayerCubit(
        repository: PlayerRepository(ApiService()),
        tokenStorage: TokenStorage(),
      ),
      child: const CreatePlayerScreen(),
    );
  }
}
