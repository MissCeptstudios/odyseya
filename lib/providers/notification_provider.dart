import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

class NotificationState {
  final bool isEnabled;
  final bool hasPermission;
  final int reminderHour;
  final int reminderMinute;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.isEnabled = false,
    this.hasPermission = false,
    this.reminderHour = 20, // Default to 8:00 PM
    this.reminderMinute = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    bool? isEnabled,
    bool? hasPermission,
    int? reminderHour,
    int? reminderMinute,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      isEnabled: isEnabled ?? this.isEnabled,
      hasPermission: hasPermission ?? this.hasPermission,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  String get reminderTimeString {
    final hour = reminderHour.toString().padLeft(2, '0');
    final minute = reminderMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
    };
  }

  factory NotificationState.fromJson(Map<String, dynamic> json) {
    return NotificationState(
      isEnabled: json['isEnabled'] ?? false,
      reminderHour: json['reminderHour'] ?? 20,
      reminderMinute: json['reminderMinute'] ?? 0,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationService _notificationService;

  NotificationNotifier(this._notificationService) : super(const NotificationState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Check if notifications are enabled
      final hasPermission = await _notificationService.areNotificationsEnabled();
      
      state = state.copyWith(
        hasPermission: hasPermission,
        isLoading: false,
      );

      if (kDebugMode) {
        debugPrint('NotificationProvider initialized - hasPermission: $hasPermission');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize notifications: $e',
      );
      if (kDebugMode) {
        debugPrint('Error initializing notifications: $e');
      }
    }
  }

  Future<bool> requestPermissions() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final granted = await _notificationService.requestPermissions();
      
      state = state.copyWith(
        hasPermission: granted,
        isLoading: false,
      );

      if (kDebugMode) {
        debugPrint('Notification permissions ${granted ? 'granted' : 'denied'}');
      }

      return granted;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to request permissions: $e',
      );
      if (kDebugMode) {
        debugPrint('Error requesting notification permissions: $e');
      }
      return false;
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    if (enabled && !state.hasPermission) {
      final granted = await requestPermissions();
      if (!granted) {
        return;
      }
    }

    state = state.copyWith(isEnabled: enabled, isLoading: true);

    try {
      if (enabled) {
        await _notificationService.scheduleDailyMoodReminderWithRandomMessage(
          hour: state.reminderHour,
          minute: state.reminderMinute,
          enabled: true,
        );
      } else {
        await _notificationService.cancelDailyMoodReminder();
      }

      state = state.copyWith(isLoading: false);

      if (kDebugMode) {
        debugPrint('Daily reminders ${enabled ? 'enabled' : 'disabled'}');
      }
    } catch (e) {
      state = state.copyWith(
        isEnabled: !enabled, // Revert the change
        isLoading: false,
        error: 'Failed to ${enabled ? 'enable' : 'disable'} notifications: $e',
      );
      if (kDebugMode) {
        debugPrint('Error toggling notifications: $e');
      }
    }
  }

  Future<void> updateReminderTime(int hour, int minute) async {
    state = state.copyWith(
      reminderHour: hour,
      reminderMinute: minute,
      isLoading: true,
    );

    try {
      if (state.isEnabled) {
        await _notificationService.scheduleDailyMoodReminderWithRandomMessage(
          hour: hour,
          minute: minute,
          enabled: true,
        );
      }

      state = state.copyWith(isLoading: false);

      if (kDebugMode) {
        debugPrint('Reminder time updated to $hour:$minute');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update reminder time: $e',
      );
      if (kDebugMode) {
        debugPrint('Error updating reminder time: $e');
      }
    }
  }

  Future<void> showTestNotification() async {
    state = state.copyWith(isLoading: true);

    try {
      if (!state.hasPermission) {
        final granted = await requestPermissions();
        if (!granted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Permission required to show notifications',
          );
          return;
        }
      }

      await _notificationService.showTestNotification();
      state = state.copyWith(isLoading: false);

      if (kDebugMode) {
        debugPrint('Test notification sent');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to show test notification: $e',
      );
      if (kDebugMode) {
        debugPrint('Error showing test notification: $e');
      }
    }
  }

  Future<void> clearError() async {
    state = state.copyWith(error: null);
  }

  // Load notification settings from storage
  void loadSettings(Map<String, dynamic> settings) {
    final notificationState = NotificationState.fromJson(settings);
    state = state.copyWith(
      isEnabled: notificationState.isEnabled,
      reminderHour: notificationState.reminderHour,
      reminderMinute: notificationState.reminderMinute,
    );

    // If notifications are enabled, reschedule them
    if (state.isEnabled && state.hasPermission) {
      _notificationService.scheduleDailyMoodReminderWithRandomMessage(
        hour: state.reminderHour,
        minute: state.reminderMinute,
        enabled: true,
      );
    }
  }

  // Get settings for saving to storage
  Map<String, dynamic> getSettings() {
    return state.toJson();
  }
}

// Provider instances
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(notificationService);
});

// Helper providers for specific state pieces
final isNotificationEnabledProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).isEnabled;
});

final hasNotificationPermissionProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).hasPermission;
});

final reminderTimeProvider = Provider<String>((ref) {
  return ref.watch(notificationProvider).reminderTimeString;
});

final notificationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).isLoading;
});

final notificationErrorProvider = Provider<String?>((ref) {
  return ref.watch(notificationProvider).error;
});