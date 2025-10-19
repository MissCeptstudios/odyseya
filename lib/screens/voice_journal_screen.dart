// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../providers/voice_journal_provider.dart';
import '../widgets/voice_recording/record_button.dart';
import '../widgets/voice_recording/audio_waveform_widget.dart';
import '../widgets/transcription/transcription_display.dart';
import '../widgets/ai_insights/insight_preview.dart';
import '../widgets/common/app_background.dart';
import '../widgets/navigation/top_navigation_bar.dart';

// Clean, minimal UX voice journal screen
class VoiceJournalScreen extends ConsumerStatefulWidget {
  const VoiceJournalScreen({super.key});

  @override
  ConsumerState<VoiceJournalScreen> createState() => _VoiceJournalScreenState();
}

class _VoiceJournalScreenState extends ConsumerState<VoiceJournalScreen>
    with TickerProviderStateMixin {
  late AnimationController _stepController;
  
  @override
  void initState() {
    super.initState();

    _stepController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceJournalProvider);
    final canSave = ref.watch(canSaveEntryProvider);

    // Handle navigation to calendar after successful save
    ref.listen<VoiceJournalState>(voiceJournalProvider, (previous, current) {
      if (current.shouldNavigateToCalendar && (previous?.shouldNavigateToCalendar != true)) {
        // Clear the navigation flag
        ref.read(voiceJournalProvider.notifier).clearNavigationFlag();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Journal saved successfully! 🎉'),
            backgroundColor: DesertColors.sageGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to calendar after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && context.mounted) {
            context.go('/calendar');
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OdyseyaTopNavigationBar(),
            Expanded(
              child: AppBackground(
                useOverlay: true,
                overlayOpacity: 0.05,
                overlayColor: DesertColors.paleDesert,
                child: Column(
                  children: [

                    // Progress Indicator
                    _buildProgressIndicator(voiceState),

                    // Main Content
                    Expanded(
                      child: _buildMainContent(voiceState),
                    ),

                    // Bottom Actions
                    _buildBottomActions(voiceState, canSave),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(VoiceJournalState voiceState) {
    final totalSteps = VoiceJournalStep.values.length - 1; // Exclude completed
    final currentStepIndex = voiceState.currentStep.index;
    final progress = currentStepIndex / totalSteps;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Progress Bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: DesertColors.dustyBlue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(DesertColors.roseSand),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Step Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: VoiceJournalStep.values
                .where((step) => step != VoiceJournalStep.completed)
                .map((step) => _buildStepIndicator(step, voiceState.currentStep))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(VoiceJournalStep step, VoiceJournalStep currentStep) {
    final isActive = step.index <= currentStep.index;
    final isCurrent = step == currentStep;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? DesertColors.roseSand
            : DesertColors.dustyBlue.withValues(alpha: 0.3),
        border: isCurrent
            ? Border.all(color: DesertColors.roseSand, width: 2)
            : null,
      ),
      child: Center(
        child: isActive
            ? Icon(
                _getStepIcon(step),
                size: 12,
                color: Colors.white,
              )
            : Text(
                '${step.index + 1}',
                style: OdyseyaTypography.captionSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: DesertColors.treeBranch,
                ),
              ),
      ),
    );
  }

  Widget _buildMainContent(VoiceJournalState voiceState) {
    switch (voiceState.currentStep) {
      case VoiceJournalStep.moodSelection:
        return _buildMoodSelectionContent();
      case VoiceJournalStep.journaling:
        return _buildJournalingContent();
      case VoiceJournalStep.review:
        return _buildReviewContent();
      case VoiceJournalStep.completed:
        return _buildCompletedContent();
    }
  }



  Widget _buildMoodSelectionContent() {
    final moods = [
      {'label': 'Joy', 'emoji': '😊', 'color': DesertColors.sageGreen},
      {'label': 'Calm', 'emoji': '😌', 'color': DesertColors.dustyBlue},
      {'label': 'Sad', 'emoji': '😢', 'color': DesertColors.roseSand},
      {'label': 'Anxious', 'emoji': '😰', 'color': DesertColors.terracotta},
      {'label': 'Angry', 'emoji': '😠', 'color': DesertColors.brownBramble},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          ...moods.map((mood) {
            final isSelected = ref.watch(voiceJournalProvider).selectedMood == mood['label'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  ref.read(voiceJournalProvider.notifier).selectMood(mood['label'] as String);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (mood['color'] as Color).withValues(alpha: 0.2)
                        : DesertColors.offWhite,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? (mood['color'] as Color)
                          : DesertColors.dustyBlue.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        mood['emoji'] as String,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        mood['label'] as String,
                        style: OdyseyaTypography.h2Large.copyWith(
                          color: DesertColors.brownBramble,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: mood['color'] as Color,
                          size: 22,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildJournalingContent() {
    final voiceState = ref.watch(voiceJournalProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Input Method Toggle - Voice / Type
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => ref.read(voiceJournalProvider.notifier).setInputMethod('voice'),
                child: Text(
                  'Voice',
                  style: OdyseyaTypography.h2.copyWith(
                    color: voiceState.inputMethod == 'voice'
                        ? DesertColors.brownBramble
                        : DesertColors.treeBranch.withValues(alpha: 0.5),
                    fontWeight: voiceState.inputMethod == 'voice'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '/',
                  style: OdyseyaTypography.h2.copyWith(
                    color: DesertColors.treeBranch.withValues(alpha: 0.3),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => ref.read(voiceJournalProvider.notifier).setInputMethod('text'),
                child: Text(
                  'Type',
                  style: OdyseyaTypography.h2.copyWith(
                    color: voiceState.inputMethod == 'text'
                        ? DesertColors.brownBramble
                        : DesertColors.treeBranch.withValues(alpha: 0.5),
                    fontWeight: voiceState.inputMethod == 'text'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Input Interface
          if (voiceState.inputMethod == 'voice') ...[
            // Audio Waveform
            if (voiceState.isRecording)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: AudioWaveformWidget(
                  amplitudeStream: ref.watch(amplitudeStreamProvider).asData?.value != null
                      ? Stream.value(ref.watch(amplitudeStreamProvider).asData!.value)
                      : null,
                  isRecording: voiceState.isRecording,
                  isPaused: voiceState.isPaused,
                  waveColor: DesertColors.dustyBlue,
                  height: 150,
                  barCount: 50,
                ),
              )
            else
              const SizedBox(height: 150), // Placeholder space when not recording

            const SizedBox(height: 32),

            // Timer Display - Minutes on left, Seconds on right
            if (voiceState.isRecording || voiceState.recordingDuration > Duration.zero)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Minutes
                    Text(
                      voiceState.recordingDuration.inMinutes.toString().padLeft(2, '0'),
                      style: OdyseyaTypography.h1Large.copyWith(
                        color: DesertColors.brownBramble,
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    // Seconds
                    Text(
                      (voiceState.recordingDuration.inSeconds % 60).toString().padLeft(2, '0'),
                      style: OdyseyaTypography.h1Large.copyWith(
                        color: DesertColors.brownBramble,
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Start Recording Button
            const RecordButton(),

            const SizedBox(height: 40),
          ] else ...[
            // Text Input Interface
            Container(
              decoration: BoxDecoration(
                color: DesertColors.offWhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: DesertColors.dustyBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          color: DesertColors.roseSand,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Write your thoughts',
                          style: OdyseyaTypography.h3.copyWith(
                            color: DesertColors.brownBramble,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: DesertColors.dustyBlue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Share what\'s on your mind...',
                        hintStyle: OdyseyaTypography.hint.copyWith(
                          color: DesertColors.treeBranch.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: OdyseyaTypography.bodyLarge.copyWith(
                        color: DesertColors.brownBramble,
                      ),
                      onChanged: (text) {
                        ref.read(voiceJournalProvider.notifier).updateTranscription(text);
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Text Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DesertColors.offWhite.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    color: DesertColors.roseSand,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Type freely about your thoughts and feelings. Take your time to express yourself fully.',
                    style: OdyseyaTypography.secondary.copyWith(
                      color: DesertColors.treeBranch,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.offWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: DesertColors.dustyBlue.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: DesertColors.sageGreen,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Your journal entry is ready',
                      style: OdyseyaTypography.h2.copyWith(
                        color: DesertColors.brownBramble,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Take a moment to review everything before saving. You can always come back and edit later.',
                  style: OdyseyaTypography.secondary.copyWith(
                    color: DesertColors.treeBranch,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Summary
          const TranscriptionDisplay(),
          
          const SizedBox(height: 16),
          
          const InsightPreview(),
        ],
      ),
    );
  }

  Widget _buildCompletedContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DesertColors.sageGreen,
                    DesertColors.sageGreen.withValues(alpha: 0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: DesertColors.sageGreen.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                size: 40,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Entry Saved Successfully',
              style: OdyseyaTypography.h1.copyWith(
                color: DesertColors.brownBramble,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              'Thank you for taking time to connect with your emotions. Your insights are valuable and will help you grow.',
              style: OdyseyaTypography.body.copyWith(
                color: DesertColors.treeBranch,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(voiceJournalProvider.notifier).startNewEntry();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesertColors.westernSunrise,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Create Another Entry',
                      style: OdyseyaTypography.button,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/calendar');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DesertColors.roseSand,
                      side: BorderSide(color: DesertColors.roseSand),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'View Your Journal',
                      style: OdyseyaTypography.button,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(VoiceJournalState voiceState, bool canSave) {
    if (voiceState.currentStep == VoiceJournalStep.completed) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesertColors.offWhite.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: DesertColors.dustyBlue.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          if (voiceState.currentStep.index > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: voiceState.isProcessing 
                    ? null 
                    : () {
                        ref.read(voiceJournalProvider.notifier).goBack();
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: DesertColors.treeBranch,
                  side: BorderSide(color: DesertColors.treeBranch),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          
          if (voiceState.currentStep.index > 0) const SizedBox(width: 16),
          
          // Primary Action Button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _getPrimaryActionEnabled(voiceState, canSave)
                  ? () => _handlePrimaryAction(voiceState)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.westernSunrise,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: voiceState.isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _getPrimaryActionText(voiceState),
                      style: OdyseyaTypography.button,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _getPrimaryActionEnabled(VoiceJournalState voiceState, bool canSave) {
    if (voiceState.isProcessing) return false;

    switch (voiceState.currentStep) {
      case VoiceJournalStep.moodSelection:
        return voiceState.selectedMood.isNotEmpty;
      case VoiceJournalStep.journaling:
        // Allow continue if has transcription (from voice or text)
        return voiceState.hasTranscription;
      case VoiceJournalStep.review:
        return canSave;
      default:
        return false;
    }
  }

  String _getPrimaryActionText(VoiceJournalState voiceState) {
    switch (voiceState.currentStep) {
      case VoiceJournalStep.moodSelection:
        return 'Continue';
      case VoiceJournalStep.journaling:
        return 'Review Entry';
      case VoiceJournalStep.review:
        return 'Save Entry';
      default:
        return 'Continue';
    }
  }

  void _handlePrimaryAction(VoiceJournalState voiceState) async {
    switch (voiceState.currentStep) {
      case VoiceJournalStep.journaling:
        // Start AI analysis before going to review
        if (voiceState.hasTranscription) {
          await ref.read(voiceJournalProvider.notifier).regenerateAnalysis();
          ref.read(voiceJournalProvider.notifier).goToStep(VoiceJournalStep.review);
        }
        break;
      case VoiceJournalStep.review:
        ref.read(voiceJournalProvider.notifier).saveEntry();
        break;
      default:
        // Move to next step
        final nextStepIndex = voiceState.currentStep.index + 1;
        if (nextStepIndex < VoiceJournalStep.values.length) {
          final nextStep = VoiceJournalStep.values[nextStepIndex];
          ref.read(voiceJournalProvider.notifier).goToStep(nextStep);
        }
        break;
    }
  }

  IconData _getStepIcon(VoiceJournalStep step) {
    switch (step) {
      case VoiceJournalStep.moodSelection:
        return Icons.sentiment_satisfied_alt;
      case VoiceJournalStep.journaling:
        return Icons.edit_note;
      case VoiceJournalStep.review:
        return Icons.preview;
      case VoiceJournalStep.completed:
        return Icons.check;
    }
  }
}