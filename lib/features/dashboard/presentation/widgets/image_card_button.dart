import 'package:flutter/material.dart';

class ImageCardButton extends StatelessWidget {
  final String imagePath;
  final Widget child;
  final double height;

  const ImageCardButton({
    super.key,
    required this.imagePath,
    required this.child,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Container(color: Colors.black.withValues(alpha: 0.35)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(alignment: Alignment.bottomCenter, child: child),
            ),
          ],
        ),
      ),
    );
  }
}
