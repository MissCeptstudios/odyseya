import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'notification_provider.dart';

enum SummaryFrequency { twoWeeks, monthly }

enum AIAnalysisLevel { minimal, standard, full }

class UserSettings {
  final bool dailyRemindersEnabled;
  final TimeOfDay reminderTime;
  final SummaryFrequency summaryFrequency;
  final AIAnalysisLevel aiAnalysisLevel;

  const UserSettings({
    this.dailyRemindersEnabled = true,
    this.reminderTime = const TimeOfDay(hour: 19, minute: 0), // 7:00 PM
    this.summaryFrequency = SummaryFrequency.twoWeeks,
    this.aiAnalysisLevel = AIAnalysisLevel.full,
  });

  UserSettings copyWith({
    bool? dailyRemindersEnabled,
    TimeOfDay? reminderTime,
    SummaryFrequency? summaryFrequency,
    AIAnalysisLevel? aiAnalysisLevel,
  }) {
    return UserSettings(
      dailyRemindersEnabled:
          dailyRemindersEnabled ?? this.dailyRemindersEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      summaryFrequency: summaryFrequency ?? this.summaryFrequency,
      aiAnalysisLevel: aiAnalysisLevel ?? this.aiAnalysisLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyRemindersEnabled': dailyRemindersEnabled,
      'reminderTimeHour': reminderTime.hour,
      'reminderTimeMinute': reminderTime.minute,
      'summaryFrequency': summaryFrequency.index,
      'aiAnalysisLevel': aiAnalysisLevel.index,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      dailyRemindersEnabled: json['dailyRemindersEnabled'] ?? true,
      reminderTime: TimeOfDay(
        hour: json['reminderTimeHour'] ?? 19,
        minute: json['reminderTimeMinute'] ?? 0,
      ),
      summaryFrequency: SummaryFrequency.values[json['summaryFrequency'] ?? 0],
      aiAnalysisLevel: AIAnalysisLevel.values[json['aiAnalysisLevel'] ?? 2],
    );
  }
}

class SettingsNotifier extends StateNotifier<UserSettings> {
  static const _storage = FlutterSecureStorage();
  static const _settingsKey = 'user_settings';
  final NotificationNotifier? _notificationNotifier;

  SettingsNotifier([this._notificationNotifier]) : super(const UserSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settingsJson = await _storage.read(key: _settingsKey);
      if (settingsJson != null) {
        final Map<String, dynamic> settings = Map<String, dynamic>.from(
          // Simple JSON parsing for stored settings
          settingsJson.split(',').fold<Map<String, dynamic>>({}, (map, item) {
            final parts = item.split(':');
            if (parts.length == 2) {
              final key = parts[0]
                  .trim()
                  .replaceAll('"', '')
                  .replaceAll('{', '')
                  .replaceAll('}', '');
              final value = parts[1].trim().replaceAll('"', '');

              // Convert string values to appropriate types
              if (value == 'true' || value == 'false') {
                map[key] = value == 'true';
              } else if (int.tryParse(value) != null) {
                map[key] = int.parse(value);
              } else {
                map[key] = value;
              }
            }
            return map;
          }),
        );
        state = UserSettings.fromJson(settings);
      }
    } catch (e) {
      // If loading fails, keep default settings
      debugPrint('Failed to load settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final settingsMap = state.toJson();
      final settingsJson = settingsMap.entries
          .map(
            (e) =>
                '"${e.key}": ${e.value is String ? '"${e.value}"' : e.value}',
          )
          .join(', ');
      await _storage.write(key: _settingsKey, value: '{$settingsJson}');
    } catch (e) {
      debugPrint('Failed to save settings: $e');
    }
  }

  Future<void> updateDailyReminders(bool enabled) async {
    state = state.copyWith(dailyRemindersEnabled: enabled);
    await _saveSettings();

    // Update notification provider
    if (_notificationNotifier != null) {
      await _notificationNotifier.toggleNotifications(enabled);
    }
  }

  Future<void> updateReminderTime(TimeOfDay time) async {
    state = state.copyWith(reminderTime: time);
    await _saveSettings();

    // Update notification provider
    if (_notificationNotifier != null) {
      await _notificationNotifier.updateReminderTime(time.hour, time.minute);
    }
  }

  Future<void> updateSummaryFrequency(SummaryFrequency frequency) async {
    state = state.copyWith(summaryFrequency: frequency);
    await _saveSettings();
  }

  Future<void> updateAIAnalysisLevel(AIAnalysisLevel level) async {
    state = state.copyWith(aiAnalysisLevel: level);
    await _saveSettings();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>((
  ref,
) {
  final notificationNotifier = ref.watch(notificationProvider.notifier);
  return SettingsNotifier(notificationNotifier);
});

// Helper extensions for display
extension SummaryFrequencyExtension on SummaryFrequency {
  String get displayName {
    switch (this) {
      case SummaryFrequency.twoWeeks:
        return 'Every 2 weeks';
      case SummaryFrequency.monthly:
        return 'Monthly';
    }
  }
}

extension AIAnalysisLevelExtension on AIAnalysisLevel {
  String get displayName {
    switch (this) {
      case AIAnalysisLevel.minimal:
        return 'Minimal analysis';
      case AIAnalysisLevel.standard:
        return 'Standard analysis';
      case AIAnalysisLevel.full:
        return 'Full analysis';
    }
  }

  String get description {
    switch (this) {
      case AIAnalysisLevel.minimal:
        return 'Basic mood tracking only';
      case AIAnalysisLevel.standard:
        return 'Mood patterns and simple insights';
      case AIAnalysisLevel.full:
        return 'Comprehensive emotional analysis and personalized suggestions';
    }
  }
}
