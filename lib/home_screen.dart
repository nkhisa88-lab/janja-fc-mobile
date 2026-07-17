import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Janja FC")),

      body: const Center(
        child: Text("Logged In Successfully", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
