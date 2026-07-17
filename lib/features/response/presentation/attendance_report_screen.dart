import 'package:flutter/material.dart';

import '../../../core/network/api_service.dart';
import '../../../core/storage/token_storage.dart';
import '../data/models/attendance_report_response.dart';
import '../data/repository/response_repository.dart';

class AttendanceReportScreen extends StatefulWidget {
  final int matchId;

  const AttendanceReportScreen({super.key, required this.matchId});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  final ResponseRepository repository = ResponseRepository(ApiService());

  final TokenStorage tokenStorage = TokenStorage();

  AttendanceReportResponse? report;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  Future<void> loadReport() async {
    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception("User not logged in");
      }

      final data = await repository.getAttendanceReport(token, widget.matchId);

      setState(() {
        report = data;
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

  Widget playerSection(String title, List<String> players, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  "$title (${players.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(),

            if (players.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("None"),
              ),

            ...players.map(
              (player) => ListTile(
                dense: true,
                leading: const Icon(Icons.person),
                title: Text(player),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Report")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : report == null
          ? const Center(child: Text("Unable to load report"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report!.opponent,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Match Date: ${report!.matchDate}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  playerSection(
                    "Available",
                    report!.available,
                    Icons.check_circle,
                  ),

                  playerSection(
                    "Unavailable",
                    report!.unavailable,
                    Icons.cancel,
                  ),

                  playerSection("Pending", report!.pending, Icons.schedule),
                ],
              ),
            ),
    );
  }
}
