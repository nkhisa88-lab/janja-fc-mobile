import 'package:fcjanja/features/response/presentation/attendance_report_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/models/match_model.dart';
import '../../data/repository/match_repository.dart';
import '../../../response/presentation/attendance_screen.dart';

class ManagerMatchesScreen extends StatefulWidget {
  const ManagerMatchesScreen({super.key});

  @override
  State<ManagerMatchesScreen> createState() => _ManagerMatchesScreenState();
}

class _ManagerMatchesScreenState extends State<ManagerMatchesScreen> {
  final MatchRepository repository = MatchRepository(ApiService());

  final TokenStorage tokenStorage = TokenStorage();

  List<MatchModel> matches = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

  Future<void> cancelMatch(int matchId) async {
    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception("User not logged in");
      }

      await repository.cancelMatch(token, matchId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Match cancelled.")));

      loadMatches();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> completeMatch(int matchId) async {
    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception("User not logged in");
      }

      await repository.completeMatch(token, matchId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Match completed.")));

      loadMatches();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> loadMatches() async {
    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception("User not logged in");
      }

      final data = await repository.getMatches(token);

      setState(() {
        matches = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Matches")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];

                return Card(
                  margin: const EdgeInsets.all(12),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          match.opponent,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text("Venue: ${match.venue}"),

                        Text("Date: ${match.matchDate}"),

                        Text("Kickoff: ${match.kickoffTime}"),

                        Text("Status: ${match.status}"),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: const Text("Attendance"),

                                onPressed: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AttendanceScreen(matchId: match.id),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AttendanceReportScreen(
                                        matchId: match.id,
                                      ),
                                    ),
                                  );
                                },

                                child: const Text("Report"),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  completeMatch(match.id);
                                },

                                child: const Text("Complete"),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  cancelMatch(match.id);
                                },

                                child: const Text("Cancel"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
