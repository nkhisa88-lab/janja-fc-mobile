import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/response/data/models/attendance_report_response.dart';
import 'package:fcjanja/features/response/data/repository/response_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_report_state.dart';

class AttendanceReportCubit extends Cubit<AttendanceReportState> {
  final ResponseRepository repository;
  final TokenStorage tokenStorage;

  AttendanceReportCubit({
    required this.repository,
    required this.tokenStorage,
  }) : super(const AttendanceReportInitial());

  Future<void> loadReport(int matchId) async {
    emit(const AttendanceReportLoading());

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const AttendanceReportFailure("User not logged in"));
        return;
      }

      final report = await repository.getAttendanceReport(
        token,
        matchId,
      );

      emit(AttendanceReportLoaded(report));
    } catch (e) {
      emit(AttendanceReportFailure(e.toString()));
    }
  }
}
