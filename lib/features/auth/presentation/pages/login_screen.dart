import 'package:flutter/material.dart';

import '../../../../core/network/api_service.dart';
import '../../data/models/login_request.dart';
import '../../data/repository/auth_repository.dart';
import 'set_password_screen.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/security/jwt_service.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final secretController = TextEditingController();
  final TokenStorage tokenStorage = TokenStorage();
  final JwtService jwtService = JwtService();

  final AuthRepository repository = AuthRepository(ApiService());

  bool loading = false;

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await repository.login(
        LoginRequest(
          phoneNumber: phoneController.text,
          secret: secretController.text,
        ),
      );

      if (!mounted) return;

      if (response.mustSetPassword) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SetPasswordScreen(activationToken: response.token!),
          ),
        );

        return;
      }

      await tokenStorage.saveToken(response.token!);

      final bool isAdmin = jwtService.isAdmin(response.token!);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(isAdmin: isAdmin)),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: secretController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password / Activation Code",
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : login,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
