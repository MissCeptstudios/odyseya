import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/mood_provider.dart';
import '../models/auth_user.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/auth_choice_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/mood_selection_screen.dart';
import '../screens/onboarding/onboarding_flow.dart';
import '../screens/onboarding/onboarding_success_screen.dart';
import '../screens/voice_journal_screen.dart';
import '../screens/journal_calendar_screen.dart';

// Router configuration
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Flow
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingFlow(),
      ),

      // Onboarding Success
      GoRoute(
        path: '/onboarding-success',
        name: 'onboarding-success',
        builder: (context, state) => const OnboardingSuccessScreen(),
      ),

      // Auth Choice Screen
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthChoiceScreen(),
      ),

      // Login Screen
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Sign Up Screen
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      // Main App Routes (protected)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MoodSelectionScreen(),
      ),

      // Journal Screen
      GoRoute(
        path: '/journal',
        name: 'journal',
        builder: (context, state) => const VoiceJournalScreen(),
      ),

      // Calendar Screen
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const JournalCalendarScreen(),
      ),
    ],

    // Redirect logic for authentication and mood selection
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final moodState = ref.read(moodProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isInitialized = authState.isInitialized;
      final isLoading = authState.isLoading;

      // Router redirect - Path: ${state.matchedLocation}
      // Auth state - $authState
      // Mood state - Has mood: ${moodState.hasMood}

      // Don't redirect if still initializing or loading
      if (!isInitialized || isLoading) {
        // Auth not ready (initializing: ${!isInitialized}, loading: $isLoading), staying on current path
        return null;
      }

      final isOnSplash = state.matchedLocation == '/splash';
      final isOnAuth = state.matchedLocation == '/auth';
      final isOnLogin = state.matchedLocation == '/login';
      final isOnSignup = state.matchedLocation == '/signup';
      final isOnOnboarding = state.matchedLocation == '/onboarding';
      final isOnOnboardingSuccess = state.matchedLocation == '/onboarding-success';
      // final isOnMoodSelection = state.matchedLocation == '/home';
      final isOnJournal = state.matchedLocation == '/journal';
      final isOnCalendar = state.matchedLocation == '/calendar';

      // Skip onboarding in development
      if (isOnSplash) {
        // Skipping onboarding in development
        return '/auth';
      }

      // If user is authenticated
      if (isAuthenticated) {
        // User is authenticated
        final lastAction = authState.lastAction;
        
        // Handle different post-authentication flows
        if (isOnSplash || isOnAuth || isOnLogin || isOnSignup) {
          // New signup goes to onboarding success
          if (lastAction == AuthAction.signUp) {
            // Redirecting new user to onboarding success
            return '/onboarding-success';
          }
          // Login goes to mood selection
          else if (lastAction == AuthAction.signIn) {
            // Redirecting returning user to mood selection
            return '/home';
          }
          // Default fallback
          // Redirecting authenticated user to home
          return '/home';
        }
        
        // Allow onboarding success for new users
        if (isOnOnboardingSuccess && lastAction == AuthAction.signUp) {
          // New user on onboarding success page
          return null;
        }
        
        // Don't allow returning users on onboarding
        if (isOnOnboarding || (isOnOnboardingSuccess && lastAction != AuthAction.signUp)) {
          // Redirecting authenticated user away from onboarding
          return '/home';
        }

        // Enforce mood selection before journal
        if (isOnJournal && !moodState.hasMood) {
          // Redirecting to mood selection - no mood selected
          return '/home';
        }

        // Authenticated user, staying on current path
        return null; // Stay on current route
      }

      // If user is not authenticated
      // User is not authenticated
      // Allow auth routes and calendar (for demo purposes)
      if (isOnAuth || isOnLogin || isOnSignup || isOnCalendar) {
        // Unauthenticated user on allowed route
        return null;
      }

      // Redirect to auth choice screen for protected routes
      // Redirecting unauthenticated user to auth choice
      return '/auth';
    },

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.toString() ?? 'Unknown error',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
