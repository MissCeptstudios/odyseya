// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation/bottom_navigation_bar.dart';
import 'action/mood_selection_screen.dart';
import 'action/recording_screen.dart';
import 'reflection/journal_calendar_screen.dart';
import 'reflection/dashboard_screen.dart';
import 'settings/settings_screen.dart';
import 'inspiration/affirmation_screen.dart';
import 'renewal/self_helper_screen.dart';

// Provider to manage current navigation index based on route
final navigationIndexProvider = Provider<int>((ref) {
  return 0; // Will be overridden in build
});

class MainAppShell extends ConsumerWidget {
  const MainAppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _getIndexFromLocation(location);
    final currentScreen = _getScreenFromLocation(location);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: currentScreen,
      ),
      bottomNavigationBar: OdyseyaBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          _navigateToTab(context, index);
        },
      ),
    );
  }

  /// Maps route location to bottom navigation index
  /// 0: Inspire (Affirmations)
  /// 1: Express (Journal/Recording)
  /// 2: Reflect (Dashboard/Journey Overview)
  /// 3: Renew (Self-Care Rituals)
  int _getIndexFromLocation(String location) {
    switch (location) {
      case '/affirmations':
        return 0; // Inspire
      case '/home':
      case '/main':
        return 1; // Express
      case '/journal':
        return 1; // Express
      case '/reflect':
      case '/dashboard':
        return 2; // Reflect
      case '/renew':
      case '/self-helper':
        return 3; // Renew
      case '/calendar':
        return 2; // Calendar moved to Reflect
      case '/settings':
        return -1; // Settings moved to top navigation, not in bottom nav
      default:
        return 0; // Default to Inspire
    }
  }

  /// Gets the appropriate screen widget based on current location
  /// Inspire: Affirmations
  /// Express: Mood Selection/Recording
  /// Reflect: Dashboard/Calendar (Journey Overview)
  /// Renew: Self-Care Rituals Hub
  Widget _getScreenFromLocation(String location) {
    switch (location) {
      case '/affirmations':
        return const AffirmationScreen(); // Inspire
      case '/home':
      case '/main':
        return const MoodSelectionScreen(); // Express
      case '/journal':
        return const RecordingScreen(); // Express
      case '/reflect':
      case '/dashboard':
        return const DashboardScreen(); // Reflect
      case '/calendar':
        return const JournalCalendarScreen(); // Calendar in Reflect
      case '/renew':
      case '/self-helper':
        return const SelfHelperScreen(); // Renew - Self-Care Hub
      case '/settings':
        return const SettingsScreen();
      default:
        return const AffirmationScreen(); // Default to Inspire
    }
  }

  /// Navigate to specific tab by index
  /// 0: Inspire, 1: Express, 2: Reflect, 3: Renew
  void _navigateToTab(BuildContext context, int index) {
    switch (index) {
      case 0: // Inspire
        context.go('/affirmations');
        break;
      case 1: // Express
        context.go('/home');
        break;
      case 2: // Reflect - Dashboard/Journey Overview
        context.go('/reflect');
        break;
      case 3: // Renew - Self-Care Rituals
        context.go('/renew');
        break;
    }
  }
}