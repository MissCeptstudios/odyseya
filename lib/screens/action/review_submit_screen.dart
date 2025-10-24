// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/voice_journal_provider.dart';
import '../../constants/typography.dart';
import '../../constants/colors.dart';

class ReviewSubmitScreen extends ConsumerStatefulWidget {
  const ReviewSubmitScreen({super.key});

  @override
  ConsumerState<ReviewSubmitScreen> createState() => _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState extends ConsumerState<ReviewSubmitScreen> {
  String? selectedMood;
  // UX Framework: Use approved color palette for mood colors
  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Happy', 'color': DesertColors.westernSunrise},
    {'emoji': '😢', 'label': 'Sad', 'color': DesertColors.arcticRain},
    {'emoji': '😰', 'label': 'Anxious', 'color': DesertColors.caramelDrizzle},
    {'emoji': '😌', 'label': 'Calm', 'color': DesertColors.waterWash},
    {'emoji': '😠', 'label': 'Angry', 'color': DesertColors.roseSand},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesertColors.creamBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Column(
                  children: [

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // How are you feeling?
                      Text(
                        'How are you feeling?',
                        style: OdyseyaTypography.h2Large.copyWith(
                          color: DesertColors.brownBramble, // Framework: Use brown for text
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Mood Selection
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: moods.length,
                          itemBuilder: (context, index) {
                            final mood = moods[index];
                            final isSelected = selectedMood == mood['label'];
                            return GestureDetector(
                              onTap: () => setState(() => selectedMood = mood['label']),
                              child: Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? DesertColors.cardWhite
                                      : DesertColors.cardWhite.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: isSelected
                                      ? Border.all(
                                          color: mood['color'],
                                          width: 3,
                                        )
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      mood['emoji'],
                                      style: const TextStyle(fontSize: 36),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      mood['label'],
                                      style: OdyseyaTypography.uiSmall.copyWith(
                                        color: isSelected
                                            ? DesertColors.brownBramble // Framework: Brown for text
                                            : DesertColors.treeBranch,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Your Entry Preview
                      Text(
                        'Your Entry',
                        style: OdyseyaTypography.h2Large.copyWith(
                          color: DesertColors.brownBramble, // Framework: Use brown for text
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: DesertColors.cardWhite, // Framework: Use cardWhite
                          borderRadius: BorderRadius.circular(16), // Framework: 16px radius
                          boxShadow: [
                            BoxShadow(
                              color: DesertColors.shadowGrey, // Framework: Use shadowGrey
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.mic,
                                  color: DesertColors.westernSunrise, // Framework: Use westernSunrise for icons
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Voice Recording',
                                  style: OdyseyaTypography.ui.copyWith(
                                    color: DesertColors.brownBramble, // Framework: Brown for text
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Duration: 00:45',
                              style: OdyseyaTypography.body.copyWith(
                                color: DesertColors.treeBranch, // Framework: Tree branch for secondary text
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to play and review your recording',
                              style: OdyseyaTypography.bodySmall.copyWith(
                                color: DesertColors.treeBranch,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: selectedMood != null ? _handleSubmit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesertColors.westernSunrise, // Framework: Use constant
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16), // Framework: 16px radius
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            'Submit Entry',
                            style: OdyseyaTypography.buttonLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Future<void> _handleSubmit() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a mood before submitting'),
          backgroundColor: DesertColors.terracotta, // Framework: Use terracotta for error/warning
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(DesertColors.cardWhite),
                  ),
                ),
                SizedBox(width: 16),
                Text('Saving your journal entry...'),
              ],
            ),
            backgroundColor: DesertColors.arcticRain, // Framework: Use arcticRain for info
            duration: const Duration(seconds: 30), // Will be dismissed when done
          ),
        );
      }

      // Update the mood in the voice journal provider
      final notifier = ref.read(voiceJournalProvider.notifier);
      notifier.selectMood(selectedMood!);

      // Save the journal entry using the provider
      // This will handle:
      // - Saving to Firestore
      // - Uploading audio to Firebase Storage
      // - Requesting AI analysis via backend
      // - Updating the entry with AI insights
      await notifier.saveEntry();

      // Check if save was successful
      final state = ref.read(voiceJournalProvider);

      if (state.error != null) {
        throw Exception(state.error);
      }

      if (mounted) {
        // Dismiss loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: DesertColors.cardWhite),
                SizedBox(width: 16),
                Expanded(
                  child: Text('Journal entry saved successfully! 🎉'),
                ),
              ],
            ),
            backgroundColor: DesertColors.arcticRain, // Framework: Use arcticRain for success
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back to calendar
        context.go('/calendar');
      }
    } catch (e) {
      if (mounted) {
        // Dismiss loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: DesertColors.cardWhite),
                const SizedBox(width: 16),
                Expanded(
                  child: Text('Error saving entry: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: DesertColors.terracotta,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
