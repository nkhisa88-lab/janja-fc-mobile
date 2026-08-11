import 'package:flutter/material.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/responsive/responsive.dart';
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
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter and confirm your password."),
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

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

      final token = response.token;

      if (token == null || token.isEmpty) {
        throw Exception("Password was saved, but no login token was returned.");
      }

      await tokenStorage.saveToken(token);

      final bool isAdmin = jwtService.isAdmin(token);

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
    } finally {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Set Password")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 30,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.lock_reset,
                    size: Responsive.isMobile(context) ? 65 : 85,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Create Your Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 24 : 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Set a new password to activate your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 14 : 16,
                    ),
                  ),

                  const SizedBox(height: 35),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (!loading) {
                        savePassword();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
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
                    height: 52,
                    child: ElevatedButton(
                      onPressed: loading ? null : savePassword,
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              "Save Password",
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
