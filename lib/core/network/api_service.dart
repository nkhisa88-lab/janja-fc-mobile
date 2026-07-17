import 'dart:convert';

import 'package:fcjanja/features/auth/data/models/login_request.dart';
import 'package:fcjanja/features/auth/data/models/login_response.dart';
import 'package:fcjanja/features/auth/data/models/set_password_request.dart';
import 'package:fcjanja/features/matches/data/models/create_match_request.dart';
import 'package:fcjanja/features/players/data/models/create_player_request.dart';
import 'package:fcjanja/features/players/data/models/create_player_response.dart';
import 'package:fcjanja/features/response/data/models/attendance_report_response.dart';
import 'package:fcjanja/features/response/data/models/attendance_response.dart';
import 'package:fcjanja/features/response/data/models/match_response_request.dart';
import 'package:http/http.dart' as http;

import '../../features/matches/data/models/match_model.dart';
import 'api_constants.dart';

class ApiService {
  Future<List<MatchModel>> getMatches(String token) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/matches"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);

      return json.map((e) => MatchModel.fromJson(e)).toList();
    }

    throw Exception("Failed to load matches");
  }

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/auth/login"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception("Login failed");
  }

  Future<void> setPassword(String token, SetPasswordRequest request) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/auth/set-password"),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to set password");
    }
  }

  Future<CreatePlayerResponse> createPlayer(
    String token,
    CreatePlayerRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/users/players"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },

      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create player");
    }

    return CreatePlayerResponse.fromJson(jsonDecode(response.body));
  }

  Future<void> createMatch(String token, CreateMatchRequest request) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/matches"),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create match");
    }
  }

  Future<void> respondToMatch(
    String token,
    MatchResponseRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/responses"),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to submit response");
    }
  }

  Future<AttendanceResponse> getAttendance(String token, int matchId) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/responses/attendance/$matchId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return AttendanceResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load attendance");
  }

  Future<void> completeMatch(String token, int matchId) async {
    final response = await http.patch(
      Uri.parse("${ApiConstants.baseUrl}/matches/$matchId/complete"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to complete match");
    }
  }

  Future<void> cancelMatch(String token, int matchId) async {
    final response = await http.patch(
      Uri.parse("${ApiConstants.baseUrl}/matches/$matchId/cancel"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to cancel match");
    }
  }

  Future<AttendanceReportResponse> getAttendanceReport(
    String token,
    int matchId,
  ) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/responses/report/$matchId"),

      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return AttendanceReportResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load attendance report");
  }
}
