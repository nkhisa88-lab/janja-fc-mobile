import 'package:fcjanja/features/response/cubit/cubit/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceScreen extends StatelessWidget {
  final int matchId;

  const AttendanceScreen({super.key, required this.matchId});

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

      body: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceFailure) {
            return Center(child: Text(state.message));
          }

          if (state is AttendanceLoaded) {
            final attendance = state.attendance;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  attendanceCard(
                    "Available",
                    attendance.available,
                    Icons.check_circle,
                  ),

                  attendanceCard(
                    "Unavailable",
                    attendance.unavailable,
                    Icons.cancel,
                  ),

                  attendanceCard("Pending", attendance.pending, Icons.schedule),
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
