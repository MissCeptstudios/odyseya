// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

enum CarouselColorVariant {
  brown, // White background with brown active
  blue,  // White background with blue active
}

class WeekDayCarousel extends StatelessWidget {
  final int selectedDayIndex; // 0 = Monday, 6 = Sunday
  final Function(int) onDaySelected;
  final CarouselColorVariant variant;

  const WeekDayCarousel({
    super.key,
    required this.selectedDayIndex,
    required this.onDaySelected,
    this.variant = CarouselColorVariant.brown,
  });

  static const List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Color get _activeColor {
    switch (variant) {
      case CarouselColorVariant.brown:
        return DesertColors.sunsetOrange; // Warm brown like quote icon
      case CarouselColorVariant.blue:
        return const Color(0xFF2196F3); // Material Blue
    }
  }

  Color get _lineColor {
    return _activeColor.withValues(alpha: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < _dayLabels.length; i++) ...[
            _buildDayItem(i),
            if (i < _dayLabels.length - 1) _buildConnectorLine(),
          ],
        ],
      ),
    );
  }

  Widget _buildDayItem(int index) {
    final isSelected = index == selectedDayIndex;
    final todayIndex = getTodayIndex();
    final isPast = index < todayIndex;

    return GestureDetector(
      onTap: () => onDaySelected(index),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPast && !isSelected
              ? _activeColor.withValues(alpha: 0.15) // Delikatny brązowy shade dla minionych dni
              : Colors.white,
          border: Border.all(
            color: isSelected ? _activeColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _activeColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            _dayLabels[index],
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? _activeColor
                  : isPast
                      ? _activeColor.withValues(alpha: 0.7) // Brązowy tekst dla minionych dni
                      : DesertColors.onSurface.withValues(alpha: 0.6),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectorLine() {
    return Container(
      width: 16,
      height: 2,
      color: _lineColor,
    );
  }

  /// Get current day index (0 = Monday, 6 = Sunday)
  static int getTodayIndex() {
    final todayWeekday = DateTime.now().weekday;
    return todayWeekday == 7 ? 6 : todayWeekday - 1;
  }

  /// Get day name from index
  static String getDayName(int index) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[index];
  }
}
