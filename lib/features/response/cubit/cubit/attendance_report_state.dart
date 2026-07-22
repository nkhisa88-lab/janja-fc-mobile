part of 'attendance_report_cubit.dart';



abstract class AttendanceReportState extends Equatable {
  const AttendanceReportState();

  @override
  List<Object?> get props => [];
}

class AttendanceReportInitial extends AttendanceReportState {
  const AttendanceReportInitial();
}

class AttendanceReportLoading extends AttendanceReportState {
  const AttendanceReportLoading();
}

class AttendanceReportLoaded extends AttendanceReportState {
  final AttendanceReportResponse report;

  const AttendanceReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class AttendanceReportFailure extends AttendanceReportState {
  final String message;

  const AttendanceReportFailure(this.message);

  @override
  List<Object?> get props => [message];
}
