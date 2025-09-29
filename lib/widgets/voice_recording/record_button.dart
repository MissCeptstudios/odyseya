import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../providers/voice_journal_provider.dart';

class RecordButton extends ConsumerStatefulWidget {
  final VoidCallback? onStartRecording;
  final VoidCallback? onStopRecording;
  final VoidCallback? onPauseRecording;
  final VoidCallback? onResumeRecording;

  const RecordButton({
    super.key,
    this.onStartRecording,
    this.onStopRecording,
    this.onPauseRecording,
    this.onResumeRecording,
  });

  @override
  ConsumerState<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends ConsumerState<RecordButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _startPulse() {
    _pulseController.repeat(reverse: true);
  }

  void _stopPulse() {
    _pulseController.stop();
    _pulseController.reset();
  }

  void _animatePress() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceJournalProvider);
    final canStartRecording = ref.watch(canStartRecordingProvider);

    // Control pulse animation based on recording state
    if (voiceState.isRecording && !voiceState.isPaused) {
      if (!_pulseController.isAnimating) {
        _startPulse();
      }
    } else {
      if (_pulseController.isAnimating) {
        _stopPulse();
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Recording Duration
        if (voiceState.isRecording || voiceState.hasRecording)
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: DesertColors.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              ref.watch(recordingProgressProvider),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: DesertColors.onSurface,
                letterSpacing: 1.0,
              ),
            ),
          ),

        // Main Record Button
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: voiceState.isRecording && !voiceState.isPaused 
                  ? _pulseAnimation.value 
                  : 1.0,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _buildMainButton(voiceState, canStartRecording),
                  );
                },
              ),
            );
          },
        ),

        // Control Buttons (when recording)
        if (voiceState.isRecording)
          Container(
            margin: const EdgeInsets.only(top: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pause/Resume Button
                _buildControlButton(
                  icon: voiceState.isPaused ? Icons.play_arrow : Icons.pause,
                  label: voiceState.isPaused ? 'Resume' : 'Pause',
                  color: DesertColors.sageGreen,
                  onPressed: voiceState.isPaused
                      ? () {
                          _animatePress();
                          widget.onResumeRecording?.call();
                          ref.read(voiceJournalProvider.notifier).resumeRecording();
                        }
                      : () {
                          _animatePress();
                          widget.onPauseRecording?.call();
                          ref.read(voiceJournalProvider.notifier).pauseRecording();
                        },
                ),

                // Stop Button
                _buildControlButton(
                  icon: Icons.stop,
                  label: 'Stop',
                  color: DesertColors.terracotta,
                  onPressed: () {
                    _animatePress();
                    widget.onStopRecording?.call();
                    ref.read(voiceJournalProvider.notifier).stopRecording();
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMainButton(VoiceJournalState voiceState, bool canStart) {
    Color buttonColor;
    IconData buttonIcon;
    String buttonLabel;
    VoidCallback? onPressed;

    if (voiceState.isRecording) {
      buttonColor = voiceState.isPaused
          ? DesertColors.sageGreen
          : DesertColors.terracotta;
      buttonIcon = voiceState.isPaused ? Icons.play_arrow : Icons.mic;
      buttonLabel = voiceState.isPaused ? 'Resume' : 'Recording...';
      onPressed = null; // Main button disabled while recording
    } else {
      buttonColor = canStart
          ? DesertColors.primary
          : DesertColors.onSecondary.withValues(alpha: 0.3);
      buttonIcon = Icons.mic;
      buttonLabel = voiceState.hasRecording ? 'Record Again' : 'Start Recording';
      onPressed = canStart
          ? () {
              HapticFeedback.mediumImpact();
              _animatePress();
              widget.onStartRecording?.call();
              ref.read(voiceJournalProvider.notifier).startRecording();
            }
          : null;
    }

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              buttonColor,
              buttonColor.withValues(alpha: 0.85),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withValues(alpha: 0.4),
              blurRadius: 24,
              spreadRadius: voiceState.isRecording && !voiceState.isPaused ? 10 : 5,
              offset: const Offset(0, 8),
            ),
            if (voiceState.isRecording && !voiceState.isPaused)
              BoxShadow(
                color: buttonColor.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 20,
                offset: const Offset(0, 0),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              buttonIcon,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              buttonLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}