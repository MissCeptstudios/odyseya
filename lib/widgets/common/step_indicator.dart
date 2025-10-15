import 'package:flutter/material.dart';
import '../../constants/colors.dart';

/// Step indicator component (numbered circles at top of screen)
/// Shows progress through a multi-step flow
class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 1-indexed
  final double spacing;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 1; i <= totalSteps; i++) ...[
            _buildStepCircle(i),
            if (i < totalSteps) SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCircle(int stepNumber) {
    final bool isActive = stepNumber == currentStep;
    final bool isCompleted = stepNumber < currentStep;

    Color backgroundColor;
    Color textColor;
    double size;

    if (isActive) {
      // Current step - larger, filled with blue
      backgroundColor = DesertColors.dustyBlue;
      textColor = Colors.white;
      size = 40;
    } else if (isCompleted) {
      // Completed step - smaller, filled with light blue
      backgroundColor = DesertColors.dustyBlue.withValues(alpha: 0.3);
      textColor = DesertColors.dustyBlue;
      size = 32;
    } else {
      // Future step - smaller, light gray
      backgroundColor = DesertColors.taupe.withValues(alpha: 0.15);
      textColor = DesertColors.taupe.withValues(alpha: 0.5);
      size = 32;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: TextStyle(
            fontSize: isActive ? 18 : 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

/// Progress bar with step indicators (alternative style)
class StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 1-indexed
  final bool showLine;

  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.showLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Column(
        children: [
          // Progress line
          if (showLine)
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: DesertColors.taupe.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(1),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: (currentStep - 1) / (totalSteps - 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: DesertColors.dustyBlue,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          if (showLine) const SizedBox(height: 8),
          // Step circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 1; i <= totalSteps; i++) _buildStepDot(i),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot(int stepNumber) {
    final bool isActive = stepNumber == currentStep;
    final bool isCompleted = stepNumber < currentStep;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isActive
            ? DesertColors.dustyBlue
            : DesertColors.taupe.withValues(alpha: 0.2),
        border: Border.all(
          color: isActive
              ? DesertColors.dustyBlue
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isCompleted || isActive
                ? Colors.white
                : DesertColors.taupe.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
