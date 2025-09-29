import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../providers/voice_journal_provider.dart';
import '../providers/mood_provider.dart';
import '../widgets/voice_recording/record_button.dart';
import '../widgets/transcription/transcription_display.dart';
import '../widgets/ai_insights/insight_preview.dart';
import '../widgets/common/app_background.dart';

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
    
    // Initialize with mood from MoodSelectionScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final moodState = ref.read(moodProvider);
      if (moodState.selectedMood != null) {
        // Transfer mood from MoodSelectionScreen
        ref.read(voiceJournalProvider.notifier).selectMood(moodState.selectedMood!.label);
      }
    });
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
              borderRadius: BorderRadius.circular(12),
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

    return AppBackground(
      useOverlay: true,
      overlayOpacity: 0.05,
      overlayColor: DesertColors.paleDesert,
      child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(voiceState),

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
    );
  }

  Widget _buildHeader(VoiceJournalState voiceState) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () {
              _showExitDialog();
            },
            icon: Icon(
              Icons.arrow_back,
              color: DesertColors.deepBrown,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStepTitle(voiceState.currentStep),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.deepBrown,
                  ),
                ),
                Text(
                  _getStepSubtitle(voiceState.currentStep),
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.taupe,
                  ),
                ),
              ],
            ),
          ),
          
          // Help Button
          IconButton(
            onPressed: () {
              _showHelpDialog(voiceState.currentStep);
            },
            icon: Icon(
              Icons.help_outline,
              color: DesertColors.taupe,
            ),
          ),
        ],
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
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: DesertColors.taupe,
                ),
              ),
      ),
    );
  }

  Widget _buildMainContent(VoiceJournalState voiceState) {
    switch (voiceState.currentStep) {
      case VoiceJournalStep.recording:
        return _buildRecordingContent();
      case VoiceJournalStep.transcription:
        return _buildTranscriptionContent();
      case VoiceJournalStep.analysis:
        return _buildAnalysisContent();
      case VoiceJournalStep.review:
        return _buildReviewContent();
      case VoiceJournalStep.completed:
        return _buildCompletedContent();
    }
  }



  Widget _buildRecordingContent() {
    final voiceState = ref.watch(voiceJournalProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Input Method Toggle
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: DesertColors.offWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: DesertColors.dustyBlue.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => ref.read(voiceJournalProvider.notifier).setInputMethod('voice'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: voiceState.inputMethod == 'voice'
                            ? DesertColors.roseSand
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic_rounded,
                            size: 18,
                            color: voiceState.inputMethod == 'voice'
                                ? Colors.white
                                : DesertColors.deepBrown,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Voice',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: voiceState.inputMethod == 'voice'
                                  ? Colors.white
                                  : DesertColors.deepBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => ref.read(voiceJournalProvider.notifier).setInputMethod('text'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: voiceState.inputMethod == 'text'
                            ? DesertColors.roseSand
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: voiceState.inputMethod == 'text'
                                ? Colors.white
                                : DesertColors.deepBrown,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Type',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: voiceState.inputMethod == 'text'
                                  ? Colors.white
                                  : DesertColors.deepBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Input Interface
          if (voiceState.inputMethod == 'voice') ...[
            // Voice Recording Interface
            const SizedBox(height: 40),
            const RecordButton(),
            const SizedBox(height: 40),
          ] else ...[
            // Text Input Interface
            Container(
              decoration: BoxDecoration(
                color: DesertColors.offWhite,
                borderRadius: BorderRadius.circular(16),
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: DesertColors.deepBrown,
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
                      borderRadius: BorderRadius.circular(12),
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
                        hintStyle: TextStyle(
                          color: DesertColors.taupe.withValues(alpha: 0.5),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: DesertColors.deepBrown,
                        height: 1.5,
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
                borderRadius: BorderRadius.circular(12),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: DesertColors.taupe,
                      height: 1.4,
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

  Widget _buildTranscriptionContent() {
    return const SingleChildScrollView(
      child: TranscriptionDisplay(),
    );
  }

  Widget _buildAnalysisContent() {
    return const SingleChildScrollView(
      child: InsightPreview(),
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
              borderRadius: BorderRadius.circular(16),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: DesertColors.deepBrown,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Take a moment to review everything before saving. You can always come back and edit later.',
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.taupe,
                    height: 1.4,
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: DesertColors.deepBrown,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              'Thank you for taking time to connect with your emotions. Your insights are valuable and will help you grow.',
              style: TextStyle(
                fontSize: 16,
                color: DesertColors.taupe,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(voiceJournalProvider.notifier).startNewEntry();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesertColors.roseSand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Another Entry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/calendar');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DesertColors.roseSand,
                      side: BorderSide(color: DesertColors.roseSand),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View Your Journal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
                  foregroundColor: DesertColors.taupe,
                  side: BorderSide(color: DesertColors.taupe),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                backgroundColor: DesertColors.roseSand,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
      case VoiceJournalStep.recording:
        // Allow continue if either has recording (voice) or has transcription (text)
        return voiceState.hasRecording || voiceState.hasTranscription;
      case VoiceJournalStep.transcription:
        return voiceState.hasTranscription;
      case VoiceJournalStep.analysis:
        return true; // Can proceed even if analysis fails
      case VoiceJournalStep.review:
        return canSave;
      default:
        return false;
    }
  }

  String _getPrimaryActionText(VoiceJournalState voiceState) {
    switch (voiceState.currentStep) {
      case VoiceJournalStep.recording:
        return 'Continue';
      case VoiceJournalStep.transcription:
        return 'Continue';
      case VoiceJournalStep.analysis:
        return 'Review Entry';
      case VoiceJournalStep.review:
        return 'Save Entry';
      default:
        return 'Continue';
    }
  }

  void _handlePrimaryAction(VoiceJournalState voiceState) {
    switch (voiceState.currentStep) {
      case VoiceJournalStep.recording:
        // If using text input, skip transcription step and go directly to analysis
        if (voiceState.inputMethod == 'text' && voiceState.hasTranscription) {
          ref.read(voiceJournalProvider.notifier).goToStep(VoiceJournalStep.analysis);
        } else {
          // Voice recording - go to transcription step
          ref.read(voiceJournalProvider.notifier).goToStep(VoiceJournalStep.transcription);
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

  String _getStepTitle(VoiceJournalStep step) {
    switch (step) {
      case VoiceJournalStep.recording:
        return 'Share Your Thoughts';
      case VoiceJournalStep.transcription:
        return 'Review Your Words';
      case VoiceJournalStep.analysis:
        return 'Discover Insights';
      case VoiceJournalStep.review:
        return 'Final Review';
      case VoiceJournalStep.completed:
        return 'Complete';
    }
  }

  String _getStepSubtitle(VoiceJournalStep step) {
    switch (step) {
      case VoiceJournalStep.recording:
        return 'Choose voice or text to express yourself';
      case VoiceJournalStep.transcription:
        return 'Your voice, in text';
      case VoiceJournalStep.analysis:
        return 'Understanding your emotions';
      case VoiceJournalStep.review:
        return 'Almost ready to save';
      case VoiceJournalStep.completed:
        return 'Thank you for sharing';
    }
  }

  IconData _getStepIcon(VoiceJournalStep step) {
    switch (step) {
      case VoiceJournalStep.recording:
        return Icons.mic;
      case VoiceJournalStep.transcription:
        return Icons.text_fields;
      case VoiceJournalStep.analysis:
        return Icons.psychology;
      case VoiceJournalStep.review:
        return Icons.preview;
      case VoiceJournalStep.completed:
        return Icons.check;
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.offWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Leave Journal Entry?',
          style: TextStyle(
            color: DesertColors.deepBrown,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Your progress will be lost if you leave now. Are you sure you want to exit?',
          style: TextStyle(
            color: DesertColors.taupe,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Stay',
              style: TextStyle(color: DesertColors.taupe),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(voiceJournalProvider.notifier).startNewEntry();
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesertColors.terracotta,
              foregroundColor: Colors.white,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(VoiceJournalStep step) {
    final helpText = _getHelpText(step);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.offWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: DesertColors.roseSand,
            ),
            const SizedBox(width: 8),
            Text(
              'How it works',
              style: TextStyle(
                color: DesertColors.deepBrown,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          helpText,
          style: TextStyle(
            color: DesertColors.taupe,
            height: 1.4,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesertColors.roseSand,
              foregroundColor: Colors.white,
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _getHelpText(VoiceJournalStep step) {
    switch (step) {
      case VoiceJournalStep.recording:
        return 'Tap the record button and speak freely about what\'s on your mind. There\'s no right or wrong way to express yourself. You can pause and resume anytime.';
      case VoiceJournalStep.transcription:
        return 'We\'ll convert your voice to text automatically. You can edit the transcription if needed to ensure it captures your thoughts accurately.';
      case VoiceJournalStep.analysis:
        return 'Our AI analyzes your words to identify emotional patterns, potential triggers, and provide supportive insights to help you understand your feelings better.';
      case VoiceJournalStep.review:
        return 'Take a moment to review your entry. You can go back to make changes or save it to your private journal.';
      case VoiceJournalStep.completed:
        return 'Your journal entry has been saved successfully. You can create another entry or explore your journal history.';
    }
  }
}