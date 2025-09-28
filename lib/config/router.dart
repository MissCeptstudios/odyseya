import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/mood_provider.dart';
import '../models/auth_user.dart';
import '../screens/first_downloadapp_screen.dart';
import '../screens/auth/auth_choice_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/mood_selection_screen.dart';
import '../screens/onboarding/onboarding_flow.dart';
import '../screens/onboarding/gdpr_consent_screen.dart';
import '../screens/onboarding/permissions_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/onboarding/onboarding_success_screen.dart';
import '../screens/onboarding/questionnaire_q1_screen.dart';
import '../screens/onboarding/questionnaire_q2_screen.dart';
import '../screens/onboarding/questionnaire_q3_screen.dart';
import '../screens/onboarding/questionnaire_q4_screen.dart';
import '../screens/affirmation_screen.dart';
import '../screens/main_app_shell.dart';

// Router configuration
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const FirstDownloadAppScreen(),
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

      // GDPR Consent Screen (before signup)
      GoRoute(
        path: '/gdpr-consent',
        name: 'gdpr-consent',
        builder: (context, state) => const GdprConsentScreen(),
      ),

      // Permissions Screen (after GDPR)
      GoRoute(
        path: '/permissions',
        name: 'permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),

      // Welcome Screen (after permissions)
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Questionnaire Routes
      GoRoute(
        path: '/onboarding/questionnaire/q1',
        name: 'questionnaire-q1',
        builder: (context, state) => const QuestionnaireQ1Screen(),
      ),

      GoRoute(
        path: '/onboarding/questionnaire/q2',
        name: 'questionnaire-q2',
        builder: (context, state) => const QuestionnaireQ2Screen(),
      ),

      GoRoute(
        path: '/onboarding/questionnaire/q3',
        name: 'questionnaire-q3',
        builder: (context, state) => const QuestionnaireQ3Screen(),
      ),

      GoRoute(
        path: '/onboarding/questionnaire/q4',
        name: 'questionnaire-q4',
        builder: (context, state) => const QuestionnaireQ4Screen(),
      ),

      // Mood Selection Screen
      GoRoute(
        path: '/mood-selection',
        name: 'mood-selection',
        builder: (context, state) => const MoodSelectionScreen(),
      ),

      // Main App with Bottom Navigation
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainAppShell(),
      ),

      // Individual tab routes (accessible via bottom navigation)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainAppShell(),
      ),

      GoRoute(
        path: '/journal',
        name: 'journal',
        builder: (context, state) => const MainAppShell(),
      ),

      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const MainAppShell(),
      ),

      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const MainAppShell(),
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

      // Standalone routes (outside bottom navigation)
      GoRoute(
        path: '/affirmation',
        name: 'affirmation',
        builder: (context, state) => const AffirmationScreen(),
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

      // Allow users to see splash screen
      if (isOnSplash) {
        // Let users stay on splash screen and use Continue button
        return null;
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
          // Login goes to home screen (main app)
          else if (lastAction == AuthAction.signIn) {
            // Redirecting returning user to main app
            return '/home';
          }
          // Default fallback
          // Redirecting authenticated user to main app
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
          return '/affirmation';
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
      // Allow auth routes, GDPR, permissions, welcome, questionnaire, journal, main app, and calendar for unauthenticated users
      final isOnGdpr = state.matchedLocation == '/gdpr-consent';
      final isOnPermissions = state.matchedLocation == '/permissions';
      final isOnWelcome = state.matchedLocation == '/welcome';
      final isOnMoodSelection = state.matchedLocation == '/mood-selection';
      final isOnQuestionnaire = state.matchedLocation.startsWith('/onboarding/questionnaire');
      final isOnMain = state.matchedLocation == '/main';
      
      if (isOnAuth || isOnLogin || isOnSignup || isOnGdpr || isOnPermissions || isOnWelcome || isOnCalendar || isOnQuestionnaire || isOnMoodSelection || isOnJournal || isOnMain) {
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
  
  // Listen to auth state changes and refresh router
  ref.listen(authStateProvider, (_, _) {
    router.refresh();
  });
  
  // Listen to mood provider changes for proper routing
  ref.listen(moodProvider, (_, _) {
    router.refresh();
  });
  
  return router;
});
