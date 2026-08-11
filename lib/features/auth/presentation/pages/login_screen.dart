import 'package:fcjanja/features/auth/cubit/cubit/login_cubit.dart';
import 'package:fcjanja/features/auth/cubit/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
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
              builder: (_) => DashboardScreen(isAdmin: user.isAdmin),
            ),
          );
        }
      },
      builder: (context, state) {
        final horizontalPadding = Responsive.horizontalPadding(context);

        return Scaffold(
          appBar: AppBar(title: const Text("Login")),

          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 30,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.sports_soccer_outlined,
                          size: Responsive.isMobile(context) ? 70 : 90,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Welcome Back",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context) ? 26 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Login to your football club account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context) ? 14 : 16,
                          ),
                        ),

                        const SizedBox(height: 35),

                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
                          controller: secretController,
                          obscureText: obscurePassword,
                          enableSuggestions: false,
                          autocorrect: false,
                          autofillHints: const <String>[],
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            if (state is! LoginLoading) {
                              context.read<LoginCubit>().login(
                                phoneNumber: phoneController.text.trim(),
                                secret: secretController.text,
                              );
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Password / Activation Code",
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

                        const SizedBox(height: 30),

                        SizedBox(
                          height: 52,
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Login",
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
          ),
        );
      },
    );
  }
}
