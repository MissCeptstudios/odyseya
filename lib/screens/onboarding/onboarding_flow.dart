import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/onboarding_provider.dart';
import 'welcome_screen.dart';
import 'permissions_screen.dart';
import 'journaling_experience_screen.dart';
import 'emotional_goals_screen.dart';
import 'preferred_time_screen.dart';
import 'privacy_preferences_screen.dart';
import 'feature_demo_screen.dart';
import 'account_creation_screen.dart';
import 'first_journal_screen.dart';

class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);

    if (onboardingData.hasCompletedOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/auth');
      });
      return const SizedBox.shrink();
    }

    switch (onboardingData.currentStep) {
      case 0:
        return const WelcomeScreen();
      case 1:
        return const PermissionsScreen();
      case 2:
        return const JournalingExperienceScreen();
      case 3:
        return const EmotionalGoalsScreen();
      case 4:
        return const PreferredTimeScreen();
      case 5:
        return const PrivacyPreferencesScreen();
      case 6:
        return const FeatureDemoScreen();
      case 7:
        return const AccountCreationScreen();
      case 8:
        return const FirstJournalScreen();
      default:
        return const WelcomeScreen();
    }
  }
}