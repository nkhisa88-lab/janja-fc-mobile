import 'dart:async';

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

  Timer? _slowLoginTimer;
  String? _loadingMessage;

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
    _slowLoginTimer?.cancel();
    super.dispose();
  }

  void _startSlowLoginTimer() {
    _slowLoginTimer?.cancel();
    setState(() {
      _loadingMessage = "Signing you in...";
    });

    _slowLoginTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _loadingMessage =
              "Still working — this can take up to 30s while the server wakes up";
        });
      }
    });
  }

  void _stopSlowLoginTimer() {
    _slowLoginTimer?.cancel();
    _slowLoginTimer = null;
    if (_loadingMessage != null) {
      setState(() {
        _loadingMessage = null;
      });
    }
  }

  void _triggerLogin(BuildContext context) {
    context.read<LoginCubit>().login(
      phoneNumber: phoneController.text.trim(),
      secret: secretController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          _startSlowLoginTimer();
        } else {
          _stopSlowLoginTimer();
        }

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
          appBar: AppBar(),

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
                              _triggerLogin(context);
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
                                : () => _triggerLogin(context),
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

                        if (_loadingMessage != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            _loadingMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
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
