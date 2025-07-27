import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/onboarding_data.dart';

class OnboardingNotifier extends StateNotifier<OnboardingData> {
  OnboardingNotifier() : super(const OnboardingData());

  void updateJournalingExperience(String experience) {
    state = state.copyWith(journalingExperience: experience);
  }

  void updateEmotionalGoals(List<String> goals) {
    state = state.copyWith(emotionalGoals: goals);
  }

  void toggleEmotionalGoal(String goal) {
    final currentGoals = List<String>.from(state.emotionalGoals);
    if (currentGoals.contains(goal)) {
      currentGoals.remove(goal);
    } else {
      currentGoals.add(goal);
    }
    state = state.copyWith(emotionalGoals: currentGoals);
  }

  void updatePreferredTime(String time) {
    state = state.copyWith(preferredTime: time);
  }

  void updatePrivacyPreference(String preference) {
    state = state.copyWith(privacyPreference: preference);
  }

  void updateMicrophonePermission(bool granted) {
    state = state.copyWith(microphonePermission: granted);
  }

  void updateNotificationPermission(bool granted) {
    state = state.copyWith(notificationPermission: granted);
  }

  void updateLocationPermission(bool granted) {
    state = state.copyWith(locationPermission: granted);
  }

  void nextStep() {
    if (state.currentStep < 8) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 8) {
      state = state.copyWith(currentStep: step);
    }
  }

  void completeOnboarding() {
    state = state.copyWith(
      hasCompletedOnboarding: true,
      currentStep: 8,
    );
  }

  void resetOnboarding() {
    state = const OnboardingData();
  }

  bool get canProceedFromCurrentStep {
    switch (state.currentStep) {
      case 0: // Welcome screen
        return true;
      case 1: // Permissions screen
        return true; // Can skip permissions
      case 2: // Journaling experience
        return state.journalingExperience != null;
      case 3: // Emotional goals
        return state.emotionalGoals.isNotEmpty;
      case 4: // Preferred time
        return state.preferredTime != null;
      case 5: // Privacy preferences
        return state.privacyPreference != null;
      case 6: // Feature demo
        return true; // Can skip demo
      case 7: // Account creation
        return true; // Can continue as guest
      case 8: // First journal entry
        return true;
      default:
        return false;
    }
  }

  double get progress {
    return (state.currentStep + 1) / 9;
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingData>(
  (ref) => OnboardingNotifier(),
);