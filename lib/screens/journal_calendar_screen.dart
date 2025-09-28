import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar/calendar_widget.dart';
import '../widgets/calendar/statistics_bar.dart';
import '../widgets/calendar/entry_preview_card.dart';
import '../widgets/common/app_background.dart';

class JournalCalendarScreen extends ConsumerWidget {
  const JournalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    final calendarNotifier = ref.read(calendarProvider.notifier);

    return AppBackground(
      useOverlay: true,
      overlayOpacity: 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        backgroundColor: DesertColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: DesertColors.onSurface,
          ),
          onPressed: () {
            // Calendar back arrow pressed - navigating back
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Your Journal',
          style: TextStyle(
            color: DesertColors.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => calendarNotifier.refreshCurrentMonth(),
            icon: Icon(
              Icons.refresh_rounded,
              color: DesertColors.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Month/Year Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: calendarNotifier.previousMonth,
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: DesertColors.primary,
                    size: 32,
                  ),
                ),
                Text(
                  _formatMonthYear(calendarState.currentMonth),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.onBackground,
                  ),
                ),
                IconButton(
                  onPressed: calendarNotifier.nextMonth,
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: DesertColors.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),

          // Statistics Bar
          StatisticsBar(
            streak: calendarState.currentStreak,
            completionRate: calendarState.monthlyCompletionRate,
            totalEntries: calendarState.totalEntriesThisMonth,
            mostFrequentMood: calendarState.mostFrequentMood,
          ),

          // Calendar Widget
          Expanded(
            child: Column(
              children: [
                // Calendar
                CalendarWidget(
                  currentMonth: calendarState.currentMonth,
                  selectedDate: calendarState.selectedDate,
                  entriesByDate: calendarState.entriesByDate,
                  onDateSelected: calendarNotifier.selectDate,
                  isLoading: calendarState.isLoading,
                ),

                // Entry Preview
                if (calendarState.selectedDateEntries.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: EntryPreviewCard(
                        entries: calendarState.selectedDateEntries,
                        selectedDate: calendarState.selectedDate,
                      ),
                    ),
                  )
                else if (!calendarState.isLoading)
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildEmptyState(context, calendarState.selectedDate),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildEmptyState(BuildContext context, DateTime selectedDate) {
    final isToday = _isToday(selectedDate);
    final isFuture = selectedDate.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DesertColors.surfaceVariant,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFuture 
              ? Icons.calendar_today_outlined 
              : isToday 
                ? Icons.edit_outlined 
                : Icons.history_outlined,
            size: 48,
            color: DesertColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            isFuture
              ? 'Future Date'
              : isToday
                ? 'No entries today'
                : 'No entries on this date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: DesertColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFuture
              ? 'You can\'t journal in the future yet!'
              : isToday
                ? 'Start your first journal entry for today'
                : 'No journal entries were created on this date',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: DesertColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          if (isToday) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to journal creation  
                Navigator.of(context).pushNamed('/journal');
              },
              icon: const Icon(Icons.mic_rounded),
              label: const Text('Start Journaling'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.primary,
                foregroundColor: DesertColors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
}