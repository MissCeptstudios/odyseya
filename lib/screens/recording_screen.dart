import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/voice_journal_provider.dart';
import '../widgets/voice_recording/audio_waveform_widget.dart';

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
              // Top Toggle Buttons
              Padding(
                padding: const EdgeInsets.all(20),
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

              const Spacer(),

              // Content Area - Record or Type
              if (isRecordMode)
                // Audio Waveform
                Container(
                  height: 200,
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
                    waveColor: const Color(0xFF5BA3C5),
                    height: 200,
                    barCount: 50,
                  ),
                )
              else
                // Text Input Area
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      hintText: 'Share your thoughts...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Color(0xFF8B7355),
                        fontSize: 16,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2B7A9E),
                      height: 1.5,
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Timer Display (only in record mode)
              if (isRecordMode && voiceState.isRecording)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(
                          _formatDuration(voiceState.recordingDuration),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Text(
                          '-${_formatDuration(const Duration(minutes: 3, seconds: 28) - voiceState.recordingDuration)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Action Button (Record or Submit)
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: GestureDetector(
                  onTap: isRecordMode ? _handleRecordButtonPress : _handleSubmit,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2B8AB8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      isRecordMode
                          ? (voiceState.isRecording ? Icons.stop : Icons.mic)
                          : Icons.arrow_forward,
                      color: Colors.white,
                      size: 45,
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

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF2B7A9E)
                : const Color(0xFF8B7355),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
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
