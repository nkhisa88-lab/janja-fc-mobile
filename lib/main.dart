import 'package:fcjanja/core/theme/app_theme.dart';
import 'package:fcjanja/features/auth/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const JanjaApp());
}

class JanjaApp extends StatelessWidget {
  const JanjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
