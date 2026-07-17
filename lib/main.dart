import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/login_screen.dart';

void main() {
  runApp(const JanjaApp());
}

class JanjaApp extends StatelessWidget {
  const JanjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
