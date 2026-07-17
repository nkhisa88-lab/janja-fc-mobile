import 'package:flutter/material.dart';

import '../../../matches/presentation/pages/create_match_screen.dart';
import '../../../matches/presentation/pages/manager_matches_screen.dart';
import '../../../players/presentation/pages/create_player_screen.dart';
import '../../../response/presentation/player_matches_screen.dart';

class DashboardScreen extends StatelessWidget {
  final bool isAdmin;

  const DashboardScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? "Manager Dashboard" : "Player Dashboard"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            isAdmin ? "Manager Functions" : "Player Functions",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          if (isAdmin) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreatePlayerScreen(),
                    ),
                  );
                },
                child: const Text("Create Player"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateMatchScreen(),
                    ),
                  );
                },
                child: const Text("Create Match"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManagerMatchesScreen(),
                    ),
                  );
                },
                child: const Text("Manage Matches"),
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PlayerMatchesScreen(),
                    ),
                  );
                },
                child: const Text("Upcoming Matches"),
              ),
            ),
          ],

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logout will be implemented later."),
                  ),
                );
              },
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
