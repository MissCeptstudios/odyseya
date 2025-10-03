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

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceJournalProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5E6D3), // Light beige top
              Color(0xFFE8CDA5), // Medium tan
              Color(0xFFD4A574), // Darker tan bottom
            ],
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

              // Audio Waveform
              if (voiceState.isRecording)
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
                ),

              const Spacer(),

              // Timer Display
              if (voiceState.isRecording)
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

              // Record Button
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: GestureDetector(
                  onTap: _handleRecordButtonPress,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2B8AB8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      voiceState.isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                ),
              ),

              // Bottom Buttons
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5BA3C5), Color(0xFF3D8AB5)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBottomButton(
                        icon: Icons.folder_outlined,
                        label: 'Library',
                        onTap: () => context.go('/calendar'),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: _buildBottomButton(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: () => context.go('/settings'),
                      ),
                    ),
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleRecordButtonPress() {
    final notifier = ref.read(voiceJournalProvider.notifier);
    final voiceState = ref.read(voiceJournalProvider);

    if (voiceState.isRecording) {
      notifier.stopRecording();
    } else {
      notifier.startRecording();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
