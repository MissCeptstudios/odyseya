class OnboardingData {
  final String? journalingExperience;
  final List<String> emotionalGoals;
  final String? preferredTime;
  final String? privacyPreference;
  final bool microphonePermission;
  final bool notificationPermission;
  final bool locationPermission;
  final bool hasCompletedOnboarding;
  final int currentStep;

  const OnboardingData({
    this.journalingExperience,
    this.emotionalGoals = const [],
    this.preferredTime,
    this.privacyPreference,
    this.microphonePermission = false,
    this.notificationPermission = false,
    this.locationPermission = false,
    this.hasCompletedOnboarding = false,
    this.currentStep = 0,
  });

  OnboardingData copyWith({
    String? journalingExperience,
    List<String>? emotionalGoals,
    String? preferredTime,
    String? privacyPreference,
    bool? microphonePermission,
    bool? notificationPermission,
    bool? locationPermission,
    bool? hasCompletedOnboarding,
    int? currentStep,
  }) {
    return OnboardingData(
      journalingExperience: journalingExperience ?? this.journalingExperience,
      emotionalGoals: emotionalGoals ?? this.emotionalGoals,
      preferredTime: preferredTime ?? this.preferredTime,
      privacyPreference: privacyPreference ?? this.privacyPreference,
      microphonePermission: microphonePermission ?? this.microphonePermission,
      notificationPermission: notificationPermission ?? this.notificationPermission,
      locationPermission: locationPermission ?? this.locationPermission,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'journalingExperience': journalingExperience,
      'emotionalGoals': emotionalGoals,
      'preferredTime': preferredTime,
      'privacyPreference': privacyPreference,
      'microphonePermission': microphonePermission,
      'notificationPermission': notificationPermission,
      'locationPermission': locationPermission,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'currentStep': currentStep,
    };
  }

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      journalingExperience: json['journalingExperience'],
      emotionalGoals: List<String>.from(json['emotionalGoals'] ?? []),
      preferredTime: json['preferredTime'],
      privacyPreference: json['privacyPreference'],
      microphonePermission: json['microphonePermission'] ?? false,
      notificationPermission: json['notificationPermission'] ?? false,
      locationPermission: json['locationPermission'] ?? false,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
      currentStep: json['currentStep'] ?? 0,
    );
  }
}

class JournalingExperience {
  static const String never = 'never';
  static const String occasionally = 'occasionally';
  static const String sometimes = 'sometimes';
  static const String regularly = 'regularly';

  static const List<Map<String, String>> options = [
    {'value': never, 'label': 'Never tried'},
    {'value': occasionally, 'label': 'Occasionally (1-2 times per month)'},
    {'value': sometimes, 'label': 'Sometimes (1-2 times per week)'},
    {'value': regularly, 'label': 'Regularly (3+ times per week)'},
  ];
}

class EmotionalGoals {
  static const String understand = 'understand';
  static const String reduce = 'reduce';
  static const String track = 'track';
  static const String improve = 'improve';
  static const String all = 'all';

  static const List<Map<String, String>> options = [
    {'value': understand, 'label': 'Better understand my emotions'},
    {'value': reduce, 'label': 'Reduce stress and anxiety'},
    {'value': track, 'label': 'Track mood patterns'},
    {'value': improve, 'label': 'Improve self-awareness'},
    {'value': all, 'label': 'All of the above'},
  ];
}

class PreferredTime {
  static const String morning = 'morning';
  static const String evening = 'evening';
  static const String anytime = 'anytime';
  static const String custom = 'custom';

  static const List<Map<String, dynamic>> options = [
    {
      'value': morning,
      'label': 'Morning',
      'description': 'Start the day mindfully',
      'icon': 'sun'
    },
    {
      'value': evening,
      'label': 'Evening',
      'description': 'Reflect on the day',
      'icon': 'moon'
    },
    {
      'value': anytime,
      'label': 'Anytime',
      'description': 'Flexible schedule',
      'icon': 'clock'
    },
    {
      'value': custom,
      'label': 'Custom time',
      'description': 'Let me choose',
      'icon': 'settings'
    },
  ];
}

class PrivacyPreference {
  static const String fullAnalysis = 'full_analysis';
  static const String gentleSuggestions = 'gentle_suggestions';
  static const String transcriptionOnly = 'transcription_only';
  static const String learnMore = 'learn_more';

  static const List<Map<String, String>> options = [
    {
      'value': fullAnalysis,
      'label': 'Full analysis (tone, triggers, patterns)',
      'description': 'Comprehensive emotional understanding'
    },
    {
      'value': gentleSuggestions,
      'label': 'Gentle suggestions only',
      'description': 'Light guidance and support'
    },
    {
      'value': transcriptionOnly,
      'label': 'Just transcription, no analysis',
      'description': 'Privacy-first approach'
    },
    {
      'value': learnMore,
      'label': 'Tell me more about each option',
      'description': 'Learn more before deciding'
    },
  ];
}