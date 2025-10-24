// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/mood.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../widgets/common/swipeable_mood_cards.dart';
import '../../providers/mood_provider.dart';

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
      backgroundColor: DesertColors.creamBeige,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: DesertColors.onSurface),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        title: null, // Removed title from AppBar
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: DesertColors.dustyBlue.withValues(alpha: 0.3),
          ),
        ),
      ),
      extendBodyBehindAppBar: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Content overlay
          Column(
            children: [
              const SizedBox(height: 24),
              // "How are you feeling?" section - no card background
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.brownBramble, // Primary Brown
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SwipeableMoodCards(
                  moods: Mood.defaultMoods,
                  onMoodSelected: _onMoodSelected,
                  selectedMood: moodState.selectedMood,
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: moodState.selectedMood != null
                          ? _onContinue
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: moodState.selectedMood != null
                            ? const Color(0xFFD8A36C) // Primary Caramel per UX framework
                            : const Color(0xFFD8A36C).withValues(alpha: 0.4), // Disabled state
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // Per UX framework
                        ),
                        shadowColor: Colors.black.withValues(alpha: 0.08),
                        disabledBackgroundColor: const Color(0xFFD8A36C).withValues(alpha: 0.4),
                        disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                      ),
                      child: Text(
                        moodState.selectedMood != null
                            ? 'CONTINUE TO JOURNAL'
                            : 'SELECT A MOOD',
                        style: OdyseyaTypography.buttonLarge,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
