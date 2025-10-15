import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/mood.dart';
import '../constants/colors.dart';
import '../widgets/swipeable_mood_cards.dart';
import '../providers/mood_provider.dart';
import '../widgets/common/app_background.dart';

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

    return AppBackground(
      useOverlay: true,
      overlayOpacity: 0.05,
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: DesertColors.offWhite.withValues(alpha: 0.95),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: DesertColors.dustyBlue.withValues(alpha: 0.3),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: SwipeableMoodCards(
                moods: Mood.defaultMoods,
                onMoodSelected: _onMoodSelected,
                selectedMood: moodState.selectedMood,
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DesertColors.offWhite.withValues(alpha: 0.95),
                  border: Border(
                    top: BorderSide(
                      color: DesertColors.dustyBlue.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                  onPressed: moodState.selectedMood != null
                      ? _onContinue
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: moodState.selectedMood != null
                        ? DesertColors.westernSunrise
                        : DesertColors.surface,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: DesertColors.surface,
                    disabledForegroundColor: DesertColors.onSurface.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  child: Text(
                    moodState.selectedMood != null
                        ? 'Continue to Journal'
                        : 'Select a mood',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    ),
    );
  }
}
