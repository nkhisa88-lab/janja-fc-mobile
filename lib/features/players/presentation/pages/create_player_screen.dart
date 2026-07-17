import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/models/create_player_request.dart';
import '../../data/repository/player_repository.dart';

class CreatePlayerScreen extends StatefulWidget {
  const CreatePlayerScreen({super.key});

  @override
  State<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  final PlayerRepository repository = PlayerRepository(ApiService());

  final TokenStorage tokenStorage = TokenStorage();

  bool loading = false;

  Future<void> createPlayer() async {
    final token = await tokenStorage.getToken();

    if (token == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      print("========== CREATE PLAYER ==========");
      print("Name: ${fullNameController.text}");
      print("Phone: ${phoneController.text}");

      final response = await repository.createPlayer(
        token,
        CreatePlayerRequest(
          fullName: fullNameController.text,
          phoneNumber: phoneController.text,
        ),
      );

      print("Player created successfully.");
      print("Activation Code: ${response.activationCode}");

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Player Created"),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Activation Code",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                SelectableText(
                  response.activationCode,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            actions: [
              TextButton(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: response.activationCode),
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Activation code copied")),
                  );
                },
                child: const Text("Copy"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Done"),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e, stackTrace) {
      print("========== CREATE PLAYER ERROR ==========");
      print(e);
      print(stackTrace);

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
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Player")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Player Name"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : createPlayer,
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Create Player"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
