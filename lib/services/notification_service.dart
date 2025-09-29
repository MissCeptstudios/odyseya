import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int _dailyReminderNotificationId = 1;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    if (kDebugMode) {
      debugPrint('NotificationService: Initialized successfully');
    }
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    if (kDebugMode) {
      debugPrint('Notification tapped: ${notificationResponse.payload}');
    }
    // Handle notification tap - could navigate to mood selection screen
    // This would typically use a navigation service or router
  }

  Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android 13+ requires notification permission
      final status = await Permission.notification.request();
      return status == PermissionStatus.granted;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final bool? result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true; // For other platforms, assume granted
  }

  Future<bool> areNotificationsEnabled() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.status;
      return status == PermissionStatus.granted;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final bool? result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions()
          .then((permissions) => permissions?.isEnabled ?? false);
      return result ?? false;
    }
    return true;
  }

  Future<void> scheduleDailyMoodReminder({
    required int hour,
    required int minute,
    bool enabled = true,
  }) async {
    if (!enabled) {
      await cancelDailyMoodReminder();
      return;
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _dailyReminderNotificationId,
      'Time for your daily check-in 🌟',
      'How are you feeling today? Take a moment to reflect on your emotions.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_mood_reminder',
          'Daily Mood Reminders',
          channelDescription: 'Daily reminders to check in with your emotions',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_mood_reminder',
    );

    if (kDebugMode) {
      debugPrint('Daily mood reminder scheduled for ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
    }
  }

  Future<void> cancelDailyMoodReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(_dailyReminderNotificationId);
    if (kDebugMode) {
      debugPrint('Daily mood reminder cancelled');
    }
  }

  Future<void> showTestNotification() async {
    await _flutterLocalNotificationsPlugin.show(
      999,
      'Odyseya Notification Test',
      'Your notifications are working perfectly! 🎉',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_notifications',
          'Test Notifications',
          channelDescription: 'Test notifications to verify setup',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'test_notification',
    );
  }

  Future<void> scheduleImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'immediate_notifications',
          'Immediate Notifications',
          channelDescription: 'Immediate notifications for app events',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    if (kDebugMode) {
      debugPrint('All notifications cancelled');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Helper method to get motivational reminder messages
  List<String> get motivationalMessages => [
    'How are you feeling today? Take a moment to reflect on your emotions.',
    'Time to check in with yourself. Your emotional journey matters. 🌟',
    'A gentle reminder to pause and connect with your inner world.',
    'Your daily emotional check-in awaits. Be kind to yourself today. 💙',
    'Take a breath and explore what your heart is telling you today.',
    'Time for your daily reflection. Every feeling is valid and important.',
    'Your emotional wellness journey continues. How are you today? 🌙',
  ];

  // Get a random motivational message
  String getRandomMotivationalMessage() {
    final messages = motivationalMessages;
    final index = DateTime.now().millisecondsSinceEpoch % messages.length;
    return messages[index];
  }

  // Schedule reminder with random motivational message
  Future<void> scheduleDailyMoodReminderWithRandomMessage({
    required int hour,
    required int minute,
    bool enabled = true,
  }) async {
    if (!enabled) {
      await cancelDailyMoodReminder();
      return;
    }

    final motivationalMessage = getRandomMotivationalMessage();

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _dailyReminderNotificationId,
      'Time for your daily check-in 🌟',
      motivationalMessage,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_mood_reminder',
          'Daily Mood Reminders',
          channelDescription: 'Daily reminders to check in with your emotions',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_mood_reminder',
    );

    if (kDebugMode) {
      debugPrint('Daily mood reminder with motivational message scheduled for ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
    }
  }
}