import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../providers/voice_journal_provider.dart';
import '../../constants/typography.dart';

class TranscriptionDisplay extends ConsumerStatefulWidget {
  const TranscriptionDisplay({super.key});

  @override
  ConsumerState<TranscriptionDisplay> createState() => _TranscriptionDisplayState();
}

class _TranscriptionDisplayState extends ConsumerState<TranscriptionDisplay>
    with TickerProviderStateMixin {
  late TextEditingController _textController;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;
  
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceJournalProvider);
    
    // Update text controller when transcription changes
    if (_textController.text != voiceState.transcription) {
      _textController.text = voiceState.transcription;
    }

    // Control loading animation
    if (voiceState.isTranscribing) {
      if (!_loadingController.isAnimating) {
        _loadingController.repeat();
      }
    } else {
      _loadingController.stop();
      _loadingController.reset();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DesertColors.waterWash.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: DesertColors.waterWash.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(voiceState),
          
          // Content
          if (voiceState.isTranscribing)
            _buildLoadingState()
          else if (voiceState.hasTranscription)
            _buildTextEditor(voiceState)
          else
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildHeader(VoiceJournalState voiceState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesertColors.waterWash.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: voiceState.isTranscribing 
                  ? DesertColors.primary
                  : voiceState.hasTranscription
                      ? DesertColors.sageGreen
                      : DesertColors.onSecondary.withValues(alpha: 0.3),
            ),
            child: Icon(
              voiceState.isTranscribing 
                  ? Icons.sync
                  : voiceState.hasTranscription
                      ? Icons.text_fields
                      : Icons.text_snippet_outlined,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voiceState.isTranscribing 
                      ? 'Converting your voice to text...'
                      : voiceState.hasTranscription
                          ? 'Your voice, in words'
                          : 'Transcription',
                  style: AppTextStyles.h4.copyWith(color: DesertColors.onSurface),
                ),
                if (voiceState.isTranscribing)
                  Text(
                    'This may take a moment',
                    style: AppTextStyles.captionSmall.copyWith(color: DesertColors.onSecondary),
                  ),
              ],
            ),
          ),
          if (voiceState.hasTranscription && !voiceState.isTranscribing)
            _buildActionButtons(voiceState),
        ],
      ),
    );
  }

  Widget _buildActionButtons(VoiceJournalState voiceState) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Retranscribe button
        if (voiceState.hasRecording)
          IconButton(
            onPressed: () {
              ref.read(voiceJournalProvider.notifier).retranscribe();
            },
            icon: Icon(
              Icons.refresh,
              color: DesertColors.primary,
              size: 20,
            ),
            tooltip: 'Retranscribe',
          ),
        
        // Word count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: DesertColors.waterWash.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${voiceState.transcription.split(' ').where((word) => word.isNotEmpty).length} words',
            style: AppTextStyles.captionSmall.copyWith(color: DesertColors.onSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      DesertColors.primary.withValues(alpha: 0.2),
                      DesertColors.primary,
                      DesertColors.primary.withValues(alpha: 0.2),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    transform: GradientRotation(_loadingAnimation.value * 6.28),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: DesertColors.surface,
                    ),
                    child: Icon(
                      Icons.mic_outlined,
                      color: DesertColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Listening to your voice...',
            style: AppTextStyles.bodyMedium.copyWith(color: DesertColors.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re carefully converting your words into text',
            style: AppTextStyles.bodySmall.copyWith(color: DesertColors.onSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTextEditor(VoiceJournalState voiceState) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _textController,
            maxLines: 8,
            style: AppTextStyles.body.copyWith(color: DesertColors.onSurface, height: 1.6),
            decoration: InputDecoration(
              hintText: 'Your transcription will appear here. You can edit it if needed.',
              hintStyle: TextStyle(
                color: DesertColors.onSecondary.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: DesertColors.waterWash.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: DesertColors.waterWash.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: DesertColors.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: DesertColors.background.withValues(alpha: 0.5),
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) {
              ref.read(voiceJournalProvider.notifier).updateTranscription(value);
            },
          ),
          
          if (voiceState.transcription.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildTranscriptionInfo(voiceState),
          ],
        ],
      ),
    );
  }

  Widget _buildTranscriptionInfo(VoiceJournalState voiceState) {
    final wordCount = voiceState.transcription.split(' ').where((word) => word.isNotEmpty).length;
    final charCount = voiceState.transcription.length;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesertColors.waterWash.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: DesertColors.onSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            '$wordCount words • $charCount characters',
            style: AppTextStyles.captionSmall.copyWith(color: DesertColors.onSecondary),
          ),
          const Spacer(),
          if (wordCount > 0)
            Text(
              'Perfect for analysis',
              style: AppTextStyles.uiSmall.copyWith(color: DesertColors.sageGreen),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DesertColors.waterWash.withValues(alpha: 0.2),
            ),
            child: Icon(
              Icons.text_snippet_outlined,
              size: 30,
              color: DesertColors.onSecondary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Record your voice first',
            style: AppTextStyles.bodyMedium.copyWith(color: DesertColors.onSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Your words will appear here as text',
            style: AppTextStyles.bodySmall.copyWith(color: DesertColors.onSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}