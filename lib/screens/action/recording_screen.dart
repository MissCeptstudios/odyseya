import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/voice_journal_provider.dart';
import '../../widgets/voice_recording/audio_waveform_widget.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';

class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({super.key});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  bool isRecordMode = true; // true = Record, false = Type
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceJournalProvider);

    return Scaffold(
      backgroundColor: DesertColors.creamBeige,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back arrow, greeting, and settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: DesertColors.brownBramble, size: 28),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Hi Mike',
                    style: AppTextStyles.h1,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: DesertColors.brownBramble, size: 28),
                    onPressed: () {
                      context.push('/settings');
                    },
                  ),
                ],
              ),
            ),

            // Main content container with cream background
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: DesertColors.creamBeige,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Question text
                    Text(
                      'Whats on your mind?',
                      style: AppTextStyles.h1,
                    ),

                    const SizedBox(height: 16),

                    // Toggle Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildToggleButton(
                              label: 'Record',
                              isSelected: isRecordMode,
                              onTap: () => setState(() => isRecordMode = true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildToggleButton(
                              label: 'Type',
                              isSelected: !isRecordMode,
                              onTap: () => setState(() => isRecordMode = false),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Content Area - Record or Type
                    if (isRecordMode) ...[
                      // Audio Waveform
                      Container(
                        height: 160,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: AudioWaveformWidget(
                          amplitudeStream:
                              ref.watch(amplitudeStreamProvider).asData?.value != null
                              ? Stream.value(
                                  ref.watch(amplitudeStreamProvider).asData!.value,
                                )
                              : null,
                          isRecording: voiceState.isRecording,
                          isPaused: voiceState.isPaused,
                          waveColor: DesertColors.waterWash,
                          height: 160,
                          barCount: 50,
                        ),
                      ),

                      const Spacer(),

                      // Timer Display
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(voiceState.recordingDuration),
                              style: AppTextStyles.h2.copyWith(
                                color: DesertColors.brownBramble,
                              ),
                            ),
                            Text(
                              _formatDuration(const Duration(minutes: 2, seconds: 30)),
                              style: AppTextStyles.h2.copyWith(
                                color: DesertColors.brownBramble,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Microphone Button
                      GestureDetector(
                        onTap: _handleRecordButtonPress,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                DesertColors.westernSunrise,
                                DesertColors.roseSand,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: DesertColors.westernSunrise.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            voiceState.isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ] else ...[
                      // Text Input Area (Type Mode)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: DesertColors.cardWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: DesertColors.waterWash.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _textController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: 'Share your thoughts...',
                              border: InputBorder.none,
                              hintStyle: AppTextStyles.hint,
                            ),
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],

                    const SizedBox(height: 16),

                    // CONTINUE Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _handleContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesertColors.westernSunrise,
                            foregroundColor: DesertColors.cardWhite,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            'Continue'.toUpperCase(),
                            style: AppTextStyles.buttonLarge.copyWith(
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? DesertColors.arcticRain : DesertColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? DesertColors.arcticRain
                : DesertColors.treeBranch.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: DesertColors.shadowGrey.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.button.copyWith(
            color: isSelected ? DesertColors.brownBramble : DesertColors.treeBranch,
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (isRecordMode) {
      if (ref.read(voiceJournalProvider).isRecording) {
        // Stop recording first
        ref.read(voiceJournalProvider.notifier).stopRecording();
      }
      _navigateToReview();
    } else {
      _handleSubmit();
    }
  }

  void _handleRecordButtonPress() {
    final notifier = ref.read(voiceJournalProvider.notifier);
    final voiceState = ref.read(voiceJournalProvider);

    if (voiceState.isRecording) {
      notifier.stopRecording();
      // Navigate to review screen after stopping
      _navigateToReview();
    } else {
      notifier.startRecording();
    }
  }

  void _handleSubmit() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something before submitting'),
          backgroundColor: Color(0xFF2B8AB8),
        ),
      );
      return;
    }
    _navigateToReview();
  }

  void _navigateToReview() {
    context.push('/review');
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
