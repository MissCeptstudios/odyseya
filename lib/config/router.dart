import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/mood_provider.dart';
import '../models/auth_user.dart';
import '../screens/splash_screen.dart';
import '../screens/marketing_screen.dart';
import '../screens/auth/auth_choice_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/action/mood_selection_screen.dart';
import '../screens/onboarding/onboarding_flow.dart';
import '../screens/onboarding/gdpr_consent_screen.dart';
import '../screens/onboarding/permissions_screen.dart';
import '../screens/onboarding/onboarding_success_screen.dart';
import '../screens/onboarding/questionnaire_q1_screen.dart';
import '../screens/onboarding/questionnaire_q2_screen.dart';
import '../screens/onboarding/questionnaire_q3_screen.dart';
import '../screens/onboarding/questionnaire_q4_screen.dart';
import '../screens/inspiration/affirmation_screen.dart';
import '../screens/inspiration/carousel_color_demo.dart';
import '../screens/main_app_shell.dart';
import '../screens/action/recording_screen.dart';
import '../screens/action/review_submit_screen.dart';
import '../screens/paywall_screen.dart';

// Custom page transition builder for smooth animations
CustomTransitionPage<void> _buildPageWithFadeTransition({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

// Custom page transition with slide from right
CustomTransitionPage<void> _buildPageWithSlideTransition({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

// Router configuration
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen - First thing users see when downloading the app
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Marketing Screen - Apple Store quality landing page
      GoRoute(
        path: '/marketing',
        name: 'marketing',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          child: const MarketingScreen(),
          state: state,
        ),
      ),

      // Onboarding Flow
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          child: const OnboardingFlow(),
          state: state,
        ),
      ),

      // Onboarding Success
      GoRoute(
        path: '/onboarding-success',
        name: 'onboarding-success',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          child: const OnboardingSuccessScreen(),
          state: state,
        ),
      ),

      // GDPR Consent Screen (before signup)
      GoRoute(
        path: '/gdpr-consent',
        name: 'gdpr-consent',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          child: const GdprConsentScreen(),
          state: state,
        ),
      ),

      // Permissions Screen (after GDPR)
      GoRoute(
        path: '/permissions',
        name: 'permissions',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          child: const PermissionsScreen(),
          state: state,
        ),
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

      // Inspire tab - Affirmations
      GoRoute(
        path: '/affirmations',
        name: 'affirmations',
        builder: (context, state) => const MainAppShell(),
      ),

      // Express tab - Mood Selection/Journal
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

      // Reflect tab - Dashboard/Journey Overview
      GoRoute(
        path: '/reflect',
        name: 'reflect',
        builder: (context, state) => const MainAppShell(),
      ),

      // Legacy /dashboard route - redirects to /reflect for backward compatibility
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const MainAppShell(),
      ),

      // Renew tab - Self-Care Rituals
      GoRoute(
        path: '/renew',
        name: 'renew',
        builder: (context, state) => const MainAppShell(),
      ),

      // Calendar (now in Reflect tab)
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const MainAppShell(),
      ),

      // Settings
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

      // Carousel Color Demo - To preview both color variants
      GoRoute(
        path: '/carousel-demo',
        name: 'carousel-demo',
        builder: (context, state) => const CarouselColorDemo(),
      ),

      // Debug route for voice recording screen testing
      GoRoute(
        path: '/test-voice',
        name: 'test-voice',
        builder: (context, state) => const RecordingScreen(),
      ),

      // Review & Submit Screen
      GoRoute(
        path: '/review',
        name: 'review',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          child: const ReviewSubmitScreen(),
          state: state,
        ),
      ),

      // Paywall / Premium Subscription Screen
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          child: const PaywallScreen(),
          state: state,
        ),
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
      final isOnOnboardingSuccess =
          state.matchedLocation == '/onboarding-success';
      // final isOnMoodSelection = state.matchedLocation == '/home';
      final isOnDashboard = state.matchedLocation == '/dashboard';
      final isOnReflect = state.matchedLocation == '/reflect';
      final isOnAffirmations = state.matchedLocation == '/affirmations';
      final isOnJournal = state.matchedLocation == '/journal';
      final isOnCalendar = state.matchedLocation == '/calendar';
      final isOnRenew = state.matchedLocation == '/renew';

      // Allow everyone to see splash screen (it auto-navigates after 3 seconds)
      if (isOnSplash) {
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
        if (isOnOnboarding ||
            (isOnOnboardingSuccess && lastAction != AuthAction.signUp)) {
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
      // Allow auth routes, GDPR, permissions, questionnaire, journal, main app, and calendar for unauthenticated users
      final isOnGdpr = state.matchedLocation == '/gdpr-consent';
      final isOnPermissions = state.matchedLocation == '/permissions';
      final isOnMoodSelection = state.matchedLocation == '/mood-selection';
      final isOnMarketing = state.matchedLocation == '/marketing';
      final isOnQuestionnaire = state.matchedLocation.startsWith(
        '/onboarding/questionnaire',
      );
      final isOnMain = state.matchedLocation == '/main';
      final isOnTestVoice = state.matchedLocation == '/test-voice';

      if (isOnAuth ||
          isOnLogin ||
          isOnSignup ||
          isOnGdpr ||
          isOnPermissions ||
          isOnDashboard ||
          isOnReflect ||
          isOnAffirmations ||
          isOnCalendar ||
          isOnRenew ||
          isOnQuestionnaire ||
          isOnMoodSelection ||
          isOnJournal ||
          isOnMain ||
          isOnMarketing ||
          isOnTestVoice) {
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
