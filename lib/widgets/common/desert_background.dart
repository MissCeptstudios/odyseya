import 'package:flutter/material.dart';

/// Desert background widget using the actual desert image from UX folder
class DesertBackground extends StatelessWidget {
  final Widget child;
  final double opacity;

  const DesertBackground({
    super.key,
    required this.child,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Dessert.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.white.withOpacity(1 - opacity),
        child: child,
      ),
    );
  }
}
