import 'package:flutter/material.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/security/jwt_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../data/models/set_password_request.dart';
import '../../data/repository/auth_repository.dart';

class SetPasswordScreen extends StatefulWidget {
  final String activationToken;

  const SetPasswordScreen({super.key, required this.activationToken});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthRepository repository = AuthRepository(ApiService());

  final TokenStorage tokenStorage = TokenStorage();

  final JwtService jwtService = JwtService();

  bool loading = false;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> savePassword() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await repository.setPassword(
        widget.activationToken,
        SetPasswordRequest(
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
        ),
      );

      if (!response.success) {
        throw Exception("Failed to save password");
      }

      await tokenStorage.saveToken(response.token!);

      final bool isAdmin = jwtService.isAdmin(response.token!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password saved successfully")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(isAdmin: isAdmin)),
        (route) => false,
      );
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
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              enableSuggestions: false,
              autocorrect: false,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: "New Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              enableSuggestions: false,
              autocorrect: false,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: "Confirm Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : savePassword,
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Save Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
