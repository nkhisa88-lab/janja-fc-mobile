import 'package:fcjanja/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:fcjanja/features/auth/presentation/pages/login_page.dart';
import 'package:fcjanja/features/matches/presentation/pages/create_match_page.dart';
import 'package:fcjanja/features/matches/presentation/pages/manager_matches_page.dart';
import 'package:fcjanja/features/players/presentation/pages/create_player_page.dart';
import 'package:fcjanja/features/response/presentation/player_matches_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    MaterialPageRoute(builder: (_) => const CreatePlayerPage()),
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
                    MaterialPageRoute(builder: (_) => const CreateMatchPage()),
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
                      builder: (_) => const ManagerMatchesPage(),
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
                      builder: (_) => const PlayerMatchesPage(),
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
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                );

                if (confirm != true || !context.mounted) return;

                await context.read<AuthCubit>().logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
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
