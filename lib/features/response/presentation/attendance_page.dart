import 'package:fcjanja/features/response/cubit/cubit/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../../../core/storage/token_storage.dart';
import '../data/repository/response_repository.dart';
import 'attendance_screen.dart';

class AttendancePage extends StatelessWidget {
  final int matchId;

  const AttendancePage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceCubit(
        repository: ResponseRepository(ApiService()),
        tokenStorage: TokenStorage(),
      )..loadAttendance(matchId),

      child: AttendanceScreen(matchId: matchId),
    );
  }
}
