import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/mood.dart';
import '../constants/colors.dart';
import '../widgets/swipeable_mood_cards.dart';
import '../providers/mood_provider.dart';

class MoodSelectionScreen extends ConsumerStatefulWidget {
  const MoodSelectionScreen({super.key});

  @override
  ConsumerState<MoodSelectionScreen> createState() =>
      _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends ConsumerState<MoodSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Initializing MoodSelectionScreen
    // Start mood selection when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moodProvider.notifier).startSelection();
    });
  }

  void _onMoodSelected(Mood mood) {
    // Mood selected: ${mood.label}
    ref.read(moodProvider.notifier).selectMood(mood);
  }

  void _onContinue() {
    final moodState = ref.read(moodProvider);
    if (moodState.selectedMood != null) {
      // Continuing with mood: ${moodState.selectedMood!.label}
      context.go('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodState = ref.watch(moodProvider);
    // Building MoodSelectionScreen, hasMood: ${moodState.hasMood}

    return Scaffold(
      backgroundColor: DesertColors.background, // Reverted to original background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: DesertColors.onSurface),
        title: const Text(
          'How are you feeling?',
          style: TextStyle(
            color: DesertColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.push('/calendar'),
            icon: const Icon(
              Icons.calendar_today_rounded,
              color: DesertColors.primary,
            ),
            tooltip: 'View Journal Calendar',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Milestone Progress Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  // Step 1: Mood (Current)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: DesertColors.westernSunrise,
                            border: Border.all(
                              color: DesertColors.westernSunrise,
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mood',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: DesertColors.westernSunrise,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Connecting Line
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: DesertColors.surface,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  
                  // Step 2: Journal (Next)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              color: DesertColors.surface,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: DesertColors.onSurface.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Journal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: DesertColors.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Take a moment to check in with yourself. Swipe through the cards and select the mood that resonates with you right now.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: DesertColors.onSurface,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: SwipeableMoodCards(
                moods: Mood.defaultMoods,
                onMoodSelected: _onMoodSelected,
                selectedMood: moodState.selectedMood,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: moodState.selectedMood != null
                      ? _onContinue
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: moodState.selectedMood != null
                        ? DesertColors.caramelDrizzle
                        : DesertColors.surface,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: DesertColors.surface,
                    disabledForegroundColor: DesertColors.onSurface.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  child: Text(
                    moodState.selectedMood != null
                        ? 'Continue with ${moodState.selectedMood!.label}'
                        : 'Select a mood to continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
