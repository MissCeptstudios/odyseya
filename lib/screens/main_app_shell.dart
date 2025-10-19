// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation/bottom_navigation_bar.dart';
import '../widgets/navigation/top_navigation_bar.dart';
import '../widgets/common/app_background.dart';
import 'dashboard_screen.dart';
import 'mood_selection_screen.dart';
import 'recording_screen.dart';
import 'journal_calendar_screen.dart';
import 'settings_screen.dart';

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
        child: Column(
          children: [
            const OdyseyaTopNavigationBar(),
            Expanded(
              child: AppBackground(
                useOverlay: true,
                overlayOpacity: 0.05,
                child: currentScreen,
              ),
            ),
          ],
        ),
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
  int _getIndexFromLocation(String location) {
    switch (location) {
      case '/dashboard':
        return 0;
      case '/home':
      case '/main':
        return 1;
      case '/journal':
        return 2;
      case '/calendar':
        return 3;
      case '/settings':
        return 4;
      default:
        return 0; // Default to Dashboard
    }
  }

  /// Gets the appropriate screen widget based on current location
  Widget _getScreenFromLocation(String location) {
    switch (location) {
      case '/dashboard':
        return const DashboardScreen();
      case '/home':
      case '/main':
        return const MoodSelectionScreen();
      case '/journal':
        return const RecordingScreen();
      case '/calendar':
        return const JournalCalendarScreen();
      case '/settings':
        return const SettingsScreen();
      default:
        return const DashboardScreen(); // Default to Dashboard
    }
  }

  /// Navigate to specific tab by index
  void _navigateToTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/home');
        break;
      case 2:
        context.go('/journal');
        break;
      case 3:
        context.go('/calendar');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}