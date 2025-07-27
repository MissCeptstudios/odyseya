import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/journal_entry.dart';
import '../../models/mood.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final Map<DateTime, List<JournalEntry>> entriesByDate;
  final Function(DateTime) onDateSelected;
  final bool isLoading;

  const CalendarWidget({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.entriesByDate,
    required this.onDateSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: DesertColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Day headers
          _buildDayHeaders(),
          const SizedBox(height: 12),
          
          // Calendar grid
          if (isLoading)
            SizedBox(
              height: 240,
              child: Center(
                child: CircularProgressIndicator(
                  color: DesertColors.primary,
                ),
              ),
            )
          else
            _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildDayHeaders() {
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return Row(
      children: dayNames.map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DesertColors.onSurfaceVariant,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    // Calculate how many days to show from previous month
    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    final lastDayOfPreviousMonth = DateTime(currentMonth.year, currentMonth.month, 0);
    
    List<Widget> dayWidgets = [];

    // Add days from previous month
    for (int i = firstDayOfWeek - 1; i >= 0; i--) {
      final day = lastDayOfPreviousMonth.day - i;
      final date = DateTime(previousMonth.year, previousMonth.month, day);
      dayWidgets.add(_buildDayWidget(date, isCurrentMonth: false));
    }

    // Add days from current month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      dayWidgets.add(_buildDayWidget(date, isCurrentMonth: true));
    }

    // Add days from next month to fill the grid
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    int nextMonthDay = 1;
    while (dayWidgets.length % 7 != 0) {
      final date = DateTime(nextMonth.year, nextMonth.month, nextMonthDay);
      dayWidgets.add(_buildDayWidget(date, isCurrentMonth: false));
      nextMonthDay++;
    }

    return Column(
      children: [
        for (int week = 0; week < dayWidgets.length / 7; week++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: dayWidgets
                  .skip(week * 7)
                  .take(7)
                  .map((widget) => Expanded(child: widget))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDayWidget(DateTime date, {required bool isCurrentMonth}) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final entries = entriesByDate[dateKey] ?? [];
    final hasEntries = entries.isNotEmpty;
    final isSelected = _isSameDay(date, selectedDate);
    final isToday = _isToday(date);
    final isFuture = date.isAfter(DateTime.now());

    // Get mood color for the date
    Color? moodColor;
    if (hasEntries) {
      final mood = entries.first.mood; // Most recent entry's mood
      moodColor = Mood.fromString(mood).color;
    }

    return GestureDetector(
      onTap: isCurrentMonth ? () => onDateSelected(date) : null,
      child: Container(
        height: 40,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? DesertColors.primary
              : hasEntries && isCurrentMonth
                  ? moodColor?.withValues(alpha: 0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isToday && isCurrentMonth
              ? Border.all(
                  color: DesertColors.primary,
                  width: 2,
                )
              : null,
        ),
        child: Stack(
          children: [
            // Day number
            Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? DesertColors.onPrimary
                      : isCurrentMonth
                          ? isFuture
                              ? DesertColors.onSurfaceVariant
                              : DesertColors.onSurface
                          : DesertColors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
            
            // Entry indicator
            if (hasEntries && isCurrentMonth && !isSelected)
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: moodColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

            // Multiple entries indicator
            if (entries.length > 1 && isCurrentMonth)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: DesertColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entries.length}',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: DesertColors.onAccent,
                      ),
                    ),
                  ),
                ),
              ),

            // Audio indicator
            if (hasEntries && entries.any((e) => e.hasAudio) && isCurrentMonth)
              Positioned(
                top: 4,
                left: 4,
                child: Icon(
                  Icons.mic_rounded,
                  size: 8,
                  color: isSelected 
                      ? DesertColors.onPrimary.withValues(alpha: 0.7)
                      : moodColor?.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }
}