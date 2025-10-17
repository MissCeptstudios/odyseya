import 'package:flutter/material.dart';

class OdyseyaTopNavigationBar extends StatelessWidget {
  const OdyseyaTopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Image.asset(
          'assets/images/Odyseya_word.png',
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
