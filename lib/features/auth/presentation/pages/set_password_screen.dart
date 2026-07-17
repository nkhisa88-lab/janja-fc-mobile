import 'package:flutter/material.dart';

import '../../../../core/network/api_service.dart';
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

  bool loading = false;

  Future<void> savePassword() async {
    setState(() {
      loading = true;
    });

    try {
      await repository.setPassword(
        widget.activationToken,
        SetPasswordRequest(
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password saved successfully")),
      );

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
      appBar: AppBar(title: const Text("Set Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : savePassword,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Save Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
