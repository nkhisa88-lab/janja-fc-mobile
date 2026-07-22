import 'package:equatable/equatable.dart';
import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/response/data/models/attendance_response.dart';
import 'package:fcjanja/features/response/data/repository/response_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final ResponseRepository repository;
  final TokenStorage tokenStorage;

  AttendanceCubit({required this.repository, required this.tokenStorage})
    : super(const AttendanceInitial());

  Future<void> loadAttendance(int matchId) async {
    emit(const AttendanceLoading());

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(const AttendanceFailure("User not logged in"));
        return;
      }

      final attendance = await repository.getAttendance(token, matchId);

      emit(AttendanceLoaded(attendance));
    } catch (e, stackTrace) {
      print("ATTENDANCE ERROR: $e");
      print(stackTrace);

      emit(AttendanceFailure(e.toString()));
    }
  }
}
