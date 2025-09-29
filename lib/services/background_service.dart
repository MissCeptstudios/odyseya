import 'package:flutter/foundation.dart';

class BackgroundService {
  static const String _dayBackground = 'assets/images/background_desert.png';
  static const String _eveningBackground = 'assets/images/background_desert.png';

  /// Returns the appropriate background image path based on current time
  /// Day: 6AM - 6PM -> background_day.png
  /// Evening: 6PM - 6AM -> background_day.png (using same for now)
  static String getCurrentBackground() {
    final now = DateTime.now();
    final hour = now.hour;

    // Day time: 6AM (06:00) to 6PM (18:00)
    // Evening time: 6PM (18:00) to 6AM (06:00)
    if (hour >= 6 && hour < 18) {
      return _dayBackground;
    } else {
      return _eveningBackground;
    }
  }

  /// Returns true if it's currently day time (6AM - 6PM)
  static bool isDayTime() {
    final hour = DateTime.now().hour;
    return hour >= 6 && hour < 18;
  }

  /// Returns true if it's currently evening/night time (6PM - 6AM)
  static bool isEveningTime() {
    return !isDayTime();
  }

  /// For debugging - allows manual time override
  @visibleForTesting
  static String getBackgroundForHour(int hour) {
    if (hour >= 6 && hour < 18) {
      return _dayBackground;
    } else {
      return _eveningBackground;
    }
  }
}