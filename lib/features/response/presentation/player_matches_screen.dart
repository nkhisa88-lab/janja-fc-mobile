import 'package:flutter/material.dart';

import '../../../core/network/api_service.dart';
import '../../../core/storage/token_storage.dart';
import '../../matches/data/models/match_model.dart';
import '../../matches/data/repository/match_repository.dart';
import '../data/models/match_response_request.dart';
import '../data/repository/response_repository.dart';

class PlayerMatchesScreen extends StatefulWidget {
  const PlayerMatchesScreen({super.key});

  @override
  State<PlayerMatchesScreen> createState() => _PlayerMatchesScreenState();
}

class _PlayerMatchesScreenState extends State<PlayerMatchesScreen> {
  final MatchRepository repository = MatchRepository(ApiService());

  final ResponseRepository responseRepository = ResponseRepository(
    ApiService(),
  );

  final TokenStorage tokenStorage = TokenStorage();

  List<MatchModel> matches = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

  Future<void> loadMatches() async {
    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception("User not logged in");
      }

      final data = await repository.getMatches(token);

      if (!mounted) return;

      setState(() {
        matches = data;
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> respond(int matchId, String status) async {
    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception("User not logged in");
      }

      setState(() {
        loading = true;
      });

      await responseRepository.respondToMatch(
        token,
        MatchResponseRequest(matchId: matchId, status: status),
      );

      await loadMatches();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Response submitted successfully.")),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upcoming Matches")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : matches.isEmpty
          ? const Center(child: Text("No upcoming matches"))
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
                                onPressed: () {
                                  respond(match.id, "AVAILABLE");
                                },
                                child: const Text("AVAILABLE"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  respond(match.id, "UNAVAILABLE");
                                },
                                child: const Text("UNAVAILABLE"),
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
