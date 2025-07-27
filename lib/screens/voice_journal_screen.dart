import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../providers/voice_journal_provider.dart';
import '../widgets/voice_recording/record_button.dart';
import '../widgets/transcription/transcription_display.dart';
import '../widgets/ai_insights/insight_preview.dart';
import '../models/mood.dart';

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

    return Scaffold(
      backgroundColor: DesertColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DesertColors.background,
              DesertColors.warmBeige.withValues(alpha: 0.3),
              DesertColors.desertMist.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: SafeArea(
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
              color: DesertColors.onSurface,
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
                    color: DesertColors.onSurface,
                  ),
                ),
                Text(
                  _getStepSubtitle(voiceState.currentStep),
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.onSecondary,
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
              color: DesertColors.onSecondary,
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
              color: DesertColors.waterWash.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(DesertColors.primary),
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
            ? DesertColors.primary 
            : DesertColors.waterWash.withValues(alpha: 0.3),
        border: isCurrent 
            ? Border.all(color: DesertColors.primary, width: 2)
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
                  color: DesertColors.onSecondary,
                ),
              ),
      ),
    );
  }

  Widget _buildMainContent(VoiceJournalState voiceState) {
    switch (voiceState.currentStep) {
      case VoiceJournalStep.moodSelection:
        return _buildMoodSelectionContent();
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

  Widget _buildMoodSelectionContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Intro Text
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.favorite,
                  size: 32,
                  color: DesertColors.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'How are you feeling right now?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the mood that best represents your current state. This helps us understand your emotional context.',
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.onSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Mood Selection
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: Mood.defaultMoods.length,
              itemBuilder: (context, index) {
                final mood = Mood.defaultMoods[index];
                return _buildMoodCard(mood);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(Mood mood) {
    final voiceState = ref.watch(voiceJournalProvider);
    final isSelected = voiceState.selectedMood == mood.label;

    return GestureDetector(
      onTap: () {
        ref.read(voiceJournalProvider.notifier).selectMood(mood.label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? mood.color.withValues(alpha: 0.2) : DesertColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? mood.color : DesertColors.waterWash.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: mood.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mood.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              mood.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? mood.color : DesertColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mood.description,
              style: TextStyle(
                fontSize: 12,
                color: DesertColors.onSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingContent() {
    return Column(
      children: [
        const Spacer(),
        
        // Recording Interface
        const RecordButton(),
        
        const Spacer(),
        
        // Instructions
        Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesertColors.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.tips_and_updates,
                color: DesertColors.primary,
                size: 20,
              ),
              const SizedBox(height: 8),
              Text(
                'Speak freely about what\'s on your mind. There\'s no right or wrong way to express yourself.',
                style: TextStyle(
                  fontSize: 14,
                  color: DesertColors.onSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
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
              color: DesertColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.3),
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
                        color: DesertColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Take a moment to review everything before saving. You can always come back and edit later.',
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.onSecondary,
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
                color: DesertColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Thank you for taking time to connect with your emotions. Your insights are valuable and will help you grow.',
              style: TextStyle(
                fontSize: 16,
                color: DesertColors.onSecondary,
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
                      backgroundColor: DesertColors.primary,
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
                      foregroundColor: DesertColors.primary,
                      side: BorderSide(color: DesertColors.primary),
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
        color: DesertColors.surface.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: DesertColors.waterWash.withValues(alpha: 0.3),
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
                  foregroundColor: DesertColors.onSecondary,
                  side: BorderSide(color: DesertColors.onSecondary),
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
                backgroundColor: DesertColors.primary,
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
      case VoiceJournalStep.moodSelection:
        return voiceState.selectedMood.isNotEmpty;
      case VoiceJournalStep.recording:
        return voiceState.hasRecording;
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
      case VoiceJournalStep.moodSelection:
        return 'Continue';
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
      case VoiceJournalStep.moodSelection:
        return 'Choose Your Mood';
      case VoiceJournalStep.recording:
        return 'Share Your Voice';
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
      case VoiceJournalStep.moodSelection:
        return 'How are you feeling right now?';
      case VoiceJournalStep.recording:
        return 'Express yourself freely';
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
      case VoiceJournalStep.moodSelection:
        return Icons.sentiment_satisfied;
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
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Leave Journal Entry?',
          style: TextStyle(
            color: DesertColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Your progress will be lost if you leave now. Are you sure you want to exit?',
          style: TextStyle(
            color: DesertColors.onSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Stay',
              style: TextStyle(color: DesertColors.onSecondary),
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
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: DesertColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'How it works',
              style: TextStyle(
                color: DesertColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          helpText,
          style: TextStyle(
            color: DesertColors.onSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesertColors.primary,
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
      case VoiceJournalStep.moodSelection:
        return 'Select the mood that best represents how you\'re feeling right now. This helps us understand the emotional context of your journal entry.';
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