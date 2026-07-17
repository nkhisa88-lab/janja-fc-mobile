import 'package:fcjanja/features/response/data/models/attendance_report_response.dart';
import 'package:fcjanja/features/response/data/models/attendance_response.dart';

import '../../../../core/network/api_service.dart';
import '../models/match_response_request.dart';

class ResponseRepository {
  final ApiService apiService;

  ResponseRepository(this.apiService);

  Future<void> respondToMatch(String token, MatchResponseRequest request) {
    return apiService.respondToMatch(token, request);
  }

  Future<AttendanceResponse> getAttendance(String token, int matchId) {
    return apiService.getAttendance(token, matchId);
  }

  Future<AttendanceReportResponse> getAttendanceReport(
    String token,
    int matchId,
  ) {
    return apiService.getAttendanceReport(token, matchId);
  }
}
