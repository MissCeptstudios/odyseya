import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../providers/settings_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/common/app_background.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notificationState = ref.watch(notificationProvider);
    final isLoading = notificationState.isLoading;
    final hasPermission = notificationState.hasPermission;

    return AppBackground(
      useOverlay: true,
      overlayOpacity: 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: DesertColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(height: 20),
              
              _buildSettingsSection(
                title: 'Notifications',
                children: [
                  _buildSettingsTile(
                    title: 'Daily Reminders',
                    subtitle: hasPermission 
                        ? 'Get gentle reminders to check in'
                        : 'Grant permission to enable reminders',
                    trailing: isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: DesertColors.primary,
                            ),
                          )
                        : Switch(
                            value: settings.dailyRemindersEnabled && hasPermission,
                            onChanged: isLoading ? null : (value) {
                              ref.read(settingsProvider.notifier).updateDailyReminders(value);
                            },
                            activeColor: DesertColors.primary,
                          ),
                  ),
                  if (hasPermission) ...[
                    _buildSettingsTile(
                      title: 'Reminder Time',
                      subtitle: _formatTime(settings.reminderTime),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: DesertColors.onSecondary,
                      ),
                      onTap: isLoading ? null : () => _showTimePicker(context, ref, settings.reminderTime),
                    ),
                    _buildSettingsTile(
                      title: 'Test Notification',
                      subtitle: 'Send a test notification to verify it\'s working',
                      trailing: const Icon(
                        Icons.notifications_active,
                        color: DesertColors.onSecondary,
                      ),
                      onTap: isLoading ? null : () => _sendTestNotification(context, ref),
                    ),
                  ],
                  if (!hasPermission)
                    _buildSettingsTile(
                      title: 'Grant Permission',
                      subtitle: 'Allow Odyseya to send you notifications',
                      trailing: const Icon(
                        Icons.security,
                        color: DesertColors.accent,
                      ),
                      onTap: isLoading ? null : () => _requestNotificationPermission(context, ref),
                    ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              _buildSettingsSection(
                title: 'Privacy & Data',
                children: [
                  _buildSettingsTile(
                    title: 'AI Analysis Level',
                    subtitle: settings.aiAnalysisLevel.displayName,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: DesertColors.onSecondary,
                    ),
                    onTap: () => _showAIAnalysisDialog(context, ref, settings.aiAnalysisLevel),
                  ),
                  _buildSettingsTile(
                    title: 'Export Data',
                    subtitle: 'Download your journal entries',
                    trailing: const Icon(
                      Icons.download,
                      color: DesertColors.onSecondary,
                    ),
                    onTap: () => _showExportDataDialog(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              _buildSettingsSection(
                title: 'Insights',
                children: [
                  _buildSettingsTile(
                    title: 'Summary Frequency',
                    subtitle: settings.summaryFrequency.displayName,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: DesertColors.onSecondary,
                    ),
                    onTap: () => _showSummaryFrequencyDialog(context, ref, settings.summaryFrequency),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // App Info
              Center(
                child: Column(
                  children: [
                    Text(
                      'Odyseya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: DesertColors.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: DesertColors.onSecondary.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: DesertColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: DesertColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: DesertColors.waterWash.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: DesertColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: DesertColors.onSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Future<void> _showTimePicker(BuildContext context, WidgetRef ref, TimeOfDay currentTime) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: DesertColors.primary,
              surface: DesertColors.surface,
              onSurface: DesertColors.onSurface,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: DesertColors.surface,
              hourMinuteTextColor: DesertColors.onSurface,
              dayPeriodTextColor: DesertColors.onSurface,
              dialHandColor: DesertColors.primary,
              dialTextColor: DesertColors.onSurface,
              entryModeIconColor: DesertColors.primary,
              helpTextStyle: TextStyle(color: DesertColors.onSecondary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      await ref.read(settingsProvider.notifier).updateReminderTime(selectedTime);
    }
  }

  Future<void> _showAIAnalysisDialog(BuildContext context, WidgetRef ref, AIAnalysisLevel currentLevel) async {
    final AIAnalysisLevel? selectedLevel = await showDialog<AIAnalysisLevel>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.psychology,
              color: DesertColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'AI Analysis Level',
              style: TextStyle(
                color: DesertColors.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AIAnalysisLevel.values.map((level) {
            final isSelected = level == currentLevel;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(level),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? DesertColors.primary 
                            : DesertColors.waterWash.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected 
                          ? DesertColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? DesertColors.primary : DesertColors.onSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                level.displayName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: DesertColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                level.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: DesertColors.onSecondary.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: DesertColors.onSecondary),
            ),
          ),
        ],
      ),
    );

    if (selectedLevel != null) {
      await ref.read(settingsProvider.notifier).updateAIAnalysisLevel(selectedLevel);
    }
  }

  Future<void> _showSummaryFrequencyDialog(BuildContext context, WidgetRef ref, SummaryFrequency currentFrequency) async {
    final SummaryFrequency? selectedFrequency = await showDialog<SummaryFrequency>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.schedule,
              color: DesertColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Summary Frequency',
              style: TextStyle(
                color: DesertColors.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How often would you like to receive emotional insights and summaries?',
              style: TextStyle(
                fontSize: 14,
                color: DesertColors.onSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ...SummaryFrequency.values.map((frequency) {
              final isSelected = frequency == currentFrequency;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(frequency),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? DesertColors.primary 
                              : DesertColors.waterWash.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected 
                            ? DesertColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: isSelected ? DesertColors.primary : DesertColors.onSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  frequency.displayName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: DesertColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  frequency == SummaryFrequency.twoWeeks 
                                      ? 'Get insights after 14 days of journaling'
                                      : 'Get insights after 30 days of journaling',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: DesertColors.onSecondary.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: DesertColors.onSecondary),
            ),
          ),
        ],
      ),
    );

    if (selectedFrequency != null) {
      await ref.read(settingsProvider.notifier).updateSummaryFrequency(selectedFrequency);
    }
  }

  Future<void> _showExportDataDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.download,
              color: DesertColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Export Your Data',
              style: TextStyle(
                color: DesertColors.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose what you\'d like to export:',
              style: TextStyle(
                fontSize: 14,
                color: DesertColors.onSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildExportOption(
              icon: Icons.article,
              title: 'Journal Entries',
              subtitle: 'All your written reflections and voice transcriptions',
              onTap: () => _exportJournalEntries(context),
            ),
            const SizedBox(height: 8),
            _buildExportOption(
              icon: Icons.psychology,
              title: 'AI Insights',
              subtitle: 'Emotional analysis and patterns from your entries',
              onTap: () => _exportAIInsights(context),
            ),
            const SizedBox(height: 8),
            _buildExportOption(
              icon: Icons.mood,
              title: 'Mood Data',
              subtitle: 'Your mood tracking history and trends',
              onTap: () => _exportMoodData(context),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DesertColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: DesertColors.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: DesertColors.accent,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Data will be exported as PDF or JSON files to your device.',
                      style: TextStyle(
                        fontSize: 12,
                        color: DesertColors.onSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: DesertColors.onSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: DesertColors.waterWash.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: DesertColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: DesertColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: DesertColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: DesertColors.onSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: DesertColors.onSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportJournalEntries(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Preparing journal entries export...'),
        backgroundColor: DesertColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
    
    // TODO: Implement actual journal entries export
    // This would typically:
    // 1. Fetch all journal entries from Firestore
    // 2. Format them as PDF or JSON
    // 3. Save to device storage or share
  }

  void _exportAIInsights(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Preparing AI insights export...'),
        backgroundColor: DesertColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
    
    // TODO: Implement actual AI insights export
  }

  void _exportMoodData(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Preparing mood data export...'),
        backgroundColor: DesertColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
    
    // TODO: Implement actual mood data export
  }

  Future<void> _requestNotificationPermission(BuildContext context, WidgetRef ref) async {
    final granted = await ref.read(notificationProvider.notifier).requestPermissions();
    
    if (!granted) {
      _showPermissionDeniedDialog(context);
    }
  }

  Future<void> _sendTestNotification(BuildContext context, WidgetRef ref) async {
    await ref.read(notificationProvider.notifier).showTestNotification();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Test notification sent! Check your notification center.'),
        backgroundColor: DesertColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.notifications_off,
              color: DesertColors.accent,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Permission Required',
              style: TextStyle(
                color: DesertColors.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'To receive daily reminders, please allow notifications in your device settings. This helps you maintain a consistent journaling habit.',
          style: TextStyle(
            fontSize: 14,
            color: DesertColors.onSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Not Now',
              style: TextStyle(color: DesertColors.onSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Open app settings - this would require the app_settings package
              // AppSettings.openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: TextStyle(color: DesertColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}