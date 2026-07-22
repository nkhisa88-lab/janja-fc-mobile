import 'package:fcjanja/features/response/cubit/cubit/attendance_report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class AttendanceReportScreen extends StatelessWidget {
  final int matchId;

  const AttendanceReportScreen({
    super.key,
    required this.matchId,
  });

  Widget playerSection(
    String title,
    List<String> players,
    IconData icon,
  ) {
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
      appBar: AppBar(
        title: const Text("Attendance Report"),
      ),

      body: BlocBuilder<AttendanceReportCubit, AttendanceReportState>(
        builder: (context, state) {
          if (state is AttendanceReportLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AttendanceReportFailure) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is AttendanceReportLoaded) {
            final report = state.report;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.opponent,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Match Date: ${report.matchDate}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  playerSection(
                    "Available",
                    report.available,
                    Icons.check_circle,
                  ),

                  playerSection(
                    "Unavailable",
                    report.unavailable,
                    Icons.cancel,
                  ),

                  playerSection(
                    "Pending",
                    report.pending,
                    Icons.schedule,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}