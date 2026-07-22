import 'package:fcjanja/features/auth/cubit/cubit/login_cubit.dart';
import 'package:fcjanja/features/auth/cubit/cubit/login_state.dart';
import 'package:fcjanja/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'set_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final secretController = TextEditingController();

  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    phoneController.clear();
    secretController.clear();
  }

  @override
  void dispose() {
    phoneController.dispose();
    secretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is LoginSuccess) {
          final user = state.user;

          if (user.mustSetPassword) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SetPasswordScreen(activationToken: user.token),
              ),
            );

            return;
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardPage(isAdmin: user.isAdmin),
            ),
          );
        }
      },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Login")),

          body: AutofillGroup(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  TextField(
                    controller: phoneController,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: secretController,
                    obscureText: obscurePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofillHints: const <String>[],
                    decoration: InputDecoration(
                      labelText: "Password / Activation Code",

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

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: state is LoginLoading
                          ? null
                          : () {
                              context.read<LoginCubit>().login(
                                phoneNumber: phoneController.text.trim(),
                                secret: secretController.text,
                              );
                            },

                      child: state is LoginLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
