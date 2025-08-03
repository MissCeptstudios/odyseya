import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../constants/colors.dart';

class MoodCard extends StatelessWidget {
  final Mood mood;
  final bool isSelected;
  final VoidCallback? onTap;

  const MoodCard({
    super.key,
    required this.mood,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white, // White background for cards
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? DesertColors.westernSunrise : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: mood.color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mood.emoji,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              mood.label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: DesertColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mood.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: DesertColors.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}