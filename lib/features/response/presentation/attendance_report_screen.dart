import 'package:fcjanja/features/response/cubit/cubit/attendance_report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceReportScreen extends StatelessWidget {
  final int matchId;

  const AttendanceReportScreen({super.key, required this.matchId});

  Widget playerSection(
    BuildContext context,
    String title,
    List<String> players,
    IconData icon,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isSmallScreen = screenWidth < 600;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 14 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: isSmallScreen ? 24 : 30),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "$title (${players.length})",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.bold,
                    ),
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
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person),
                title: Text(
                  player,
                  style: TextStyle(fontSize: isSmallScreen ? 15 : 17),
                ),
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

      body: BlocBuilder<AttendanceReportCubit, AttendanceReportState>(
        builder: (context, state) {
          if (state is AttendanceReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceReportFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }

          if (state is AttendanceReportLoaded) {
            final report = state.report;

            return LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;

                final horizontalPadding = screenWidth < 600 ? 16.0 : 40.0;

                final contentWidth = screenWidth > 900
                    ? 800.0
                    : double.infinity;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 20,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.opponent,
                            style: TextStyle(
                              fontSize: screenWidth < 600 ? 24 : 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Match Date: ${report.matchDate}",
                            style: TextStyle(
                              fontSize: screenWidth < 600 ? 16 : 18,
                            ),
                          ),

                          const SizedBox(height: 24),

                          playerSection(
                            context,
                            "Available",
                            report.available,
                            Icons.check_circle,
                          ),

                          playerSection(
                            context,
                            "Unavailable",
                            report.unavailable,
                            Icons.cancel,
                          ),

                          playerSection(
                            context,
                            "Pending",
                            report.pending,
                            Icons.schedule,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
