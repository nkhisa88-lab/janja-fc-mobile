import 'package:fcjanja/core/storage/token_storage.dart';
import 'package:fcjanja/features/auth/presentation/pages/login_page.dart';
import 'package:fcjanja/features/matches/presentation/pages/create_match_page.dart';
import 'package:fcjanja/features/matches/presentation/pages/manager_matches_page.dart';
import 'package:fcjanja/features/players/presentation/pages/create_player_page.dart';
import 'package:fcjanja/features/response/presentation/player_matches_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';

class DashboardScreen extends StatelessWidget {
  final bool isAdmin;

  const DashboardScreen({super.key, required this.isAdmin});

  Future<void> logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirm != true || !context.mounted) {
      return;
    }

    await TokenStorage().deleteToken();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget dashboardButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget managerFunctions(BuildContext context) {
    final buttons = [
      dashboardButton(
        context: context,
        text: "Create Player",
        icon: Icons.person_add,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePlayerPage()),
          );
        },
      ),
      dashboardButton(
        context: context,
        text: "Create Match",
        icon: Icons.add_circle_outline,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateMatchPage()),
          );
        },
      ),
      dashboardButton(
        context: context,
        text: "Manage Matches",
        icon: Icons.sports_soccer,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ManagerMatchesPage()),
          );
        },
      ),
    ];

    if (Responsive.isDesktop(context)) {
      return Row(
        children: [
          Expanded(child: buttons[0]),
          const SizedBox(width: 16),
          Expanded(child: buttons[1]),
          const SizedBox(width: 16),
          Expanded(child: buttons[2]),
        ],
      );
    }

    if (Responsive.isTablet(context)) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: buttons.map((button) {
          return SizedBox(width: 350, child: button);
        }).toList(),
      );
    }

    return Column(
      children: [
        buttons[0],
        const SizedBox(height: 15),
        buttons[1],
        const SizedBox(height: 15),
        buttons[2],
      ],
    );
  }

  Widget playerFunctions(BuildContext context) {
    return dashboardButton(
      context: context,
      text: "Upcoming Matches",
      icon: Icons.calendar_month,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlayerMatchesPage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(elevation: 1.0),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.contentMaxWidth(context),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAdmin ? "Manager Functions" : "Player Functions",
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 22 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (isAdmin)
                    managerFunctions(context)
                  else
                    playerFunctions(context),

                  const SizedBox(height: 50),

                  const Divider(),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => logout(context),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
