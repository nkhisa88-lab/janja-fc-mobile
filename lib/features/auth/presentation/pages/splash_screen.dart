import 'dart:async';

import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Image bgImage;

  @override
  void initState() {
    super.initState();
    // 1. Pre-cache the background image asset for instant rendering
    bgImage = Image.asset('assets/images/janja.jpeg', fit: BoxFit.cover);
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(bgImage.image, context);
  }

  Future<void> _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SplashBody(bgImage: bgImage);
  }
}

class _SplashBody extends StatelessWidget {
  final Image bgImage;

  const _SplashBody({required this.bgImage});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // 2. BACKGROUND IMAGE LAYER: Fills the entire screen
          Positioned.fill(child: bgImage),

          // 3. OVERLAY TINT LAYER: Darkens the image so white text is highly readable
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(
                180,
              ), // Adjust darkness here (0 to 255)
            ),
          ),

          // 4. FOREGROUND CONTENT LAYER: Centers the "WELCOME" text
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "WELCOME",
                  textAlign: TextAlign.center,
                  style: textTheme.displayMedium?.copyWith(
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .white, // Made explicitly white to contrast with dark overlay
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
