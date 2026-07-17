import 'package:flutter/material.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/models/create_match_request.dart';
import '../../data/repository/match_repository.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final opponentController = TextEditingController();
  final venueController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final MatchRepository repository = MatchRepository(ApiService());

  final TokenStorage tokenStorage = TokenStorage();

  bool loading = false;

  Future<void> createMatch() async {
    final token = await tokenStorage.getToken();

    if (token == null) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await repository.createMatch(
        token,

        CreateMatchRequest(
          opponent: opponentController.text,

          venue: venueController.text,

          matchDate: dateController.text,

          kickoffTime: timeController.text,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Match Created")));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Match")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: opponentController,
              decoration: const InputDecoration(labelText: "Opponent"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: venueController,
              decoration: const InputDecoration(labelText: "Venue"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: "Match Date (YYYY-MM-DD)",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: "Kickoff Time (HH:mm:ss)",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: loading ? null : createMatch,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Create Match"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
