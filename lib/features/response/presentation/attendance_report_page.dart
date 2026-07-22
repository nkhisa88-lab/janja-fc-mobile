import 'package:fcjanja/features/response/cubit/cubit/attendance_report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../../../core/storage/token_storage.dart';
import '../data/repository/response_repository.dart';
import 'attendance_report_screen.dart';

class AttendanceReportPage extends StatelessWidget {
  final int matchId;

  const AttendanceReportPage({
    super.key,
    required this.matchId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceReportCubit(
        repository: ResponseRepository(ApiService()),
        tokenStorage: TokenStorage(),
      )..loadReport(matchId),

      child: AttendanceReportScreen(
        matchId: matchId,
      ),
    );
  }
}