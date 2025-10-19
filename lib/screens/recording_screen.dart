import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/voice_journal_provider.dart';
import '../widgets/voice_recording/audio_waveform_widget.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background_F.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
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
                      style: OdyseyaTypography.h1,
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
                      const SizedBox(height: 24),

                      // Question text
                      Text(
                        'Whats on your mind?',
                        style: OdyseyaTypography.h1Large,
                      ),

                      const SizedBox(height: 24),

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

                      const SizedBox(height: 32),

                      // Content Area - Record or Type
                      if (isRecordMode) ...[
                        // Audio Waveform
                        Container(
                          height: 180,
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
                            height: 180,
                            barCount: 50,
                          ),
                        ),

                        const Spacer(),

                        // Timer Display
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(voiceState.recordingDuration),
                                style: OdyseyaTypography.h1Large.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                _formatDuration(const Duration(minutes: 2, seconds: 30)),
                                style: OdyseyaTypography.h1Large.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Microphone Button
                        GestureDetector(
                          onTap: _handleRecordButtonPress,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DesertColors.waterWash,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              voiceState.isRecording ? Icons.stop : Icons.mic,
                              color: Colors.white,
                              size: 56,
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
                              color: Colors.white,
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
                                hintStyle: OdyseyaTypography.hint,
                              ),
                              style: OdyseyaTypography.bodyLarge,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],

                      const SizedBox(height: 32),

                      // CONTINUE Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DesertColors.westernSunrise,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: Colors.black.withValues(alpha: 0.25),
                            ),
                            child: Text(
                              'CONTINUE',
                              style: OdyseyaTypography.buttonLarge,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Bar
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: DesertColors.creamBeige,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.calendar_today, 'Calendar', false),
                    _buildNavItem(Icons.home, 'Home', true),
                    _buildNavItem(Icons.calendar_month, 'Calendar', false),
                  ],
                ),
              ),
            ],
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? DesertColors.waterWash : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: OdyseyaTypography.button.copyWith(
            color: isSelected ? Colors.white : DesertColors.caramelDrizzle,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? DesertColors.caramelDrizzle : DesertColors.treeBranch,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: isActive ? OdyseyaTypography.navActive : OdyseyaTypography.navInactive,
        ),
      ],
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
