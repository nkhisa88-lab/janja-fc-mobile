import 'package:flutter/material.dart';

import '../../../core/storage/token_storage.dart';
import '../data/models/attendance_response.dart';
import '../data/repository/response_repository.dart';
import '../../../core/network/api_service.dart';

class AttendanceScreen extends StatefulWidget {
  final int matchId;

  const AttendanceScreen({super.key, required this.matchId});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ResponseRepository repository = ResponseRepository(ApiService());

  final TokenStorage tokenStorage = TokenStorage();

  AttendanceResponse? attendance;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception("User not logged in");
      }

      final data = await repository.getAttendance(token, widget.matchId);

      setState(() {
        attendance = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget attendanceCard(String title, int value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value.toString(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Summary")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : attendance == null
          ? const Center(child: Text("Unable to load attendance"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  attendanceCard(
                    "Available",
                    attendance!.available,
                    Icons.check_circle,
                  ),
                  attendanceCard(
                    "Unavailable",
                    attendance!.unavailable,
                    Icons.cancel,
                  ),
                  attendanceCard(
                    "Pending",
                    attendance!.pending,
                    Icons.schedule,
                  ),
                ],
              ),
            ),
    );
  }
}
