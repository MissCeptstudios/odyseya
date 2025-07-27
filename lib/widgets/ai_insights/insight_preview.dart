import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/ai_analysis.dart';
import '../../providers/voice_journal_provider.dart';

class InsightPreview extends ConsumerStatefulWidget {
  const InsightPreview({super.key});

  @override
  ConsumerState<InsightPreview> createState() => _InsightPreviewState();
}

class _InsightPreviewState extends ConsumerState<InsightPreview>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _expandController;
  late Animation<double> _loadingAnimation;
  late Animation<double> _expandAnimation;
  
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceJournalProvider);
    
    // Control loading animation
    if (voiceState.isAnalyzing) {
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
          if (voiceState.isAnalyzing)
            _buildLoadingState()
          else if (voiceState.hasAnalysis)
            _buildAnalysisContent(voiceState.aiAnalysis!)
          else if (voiceState.currentStep.index >= VoiceJournalStep.analysis.index)
            _buildErrorState()
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
              color: voiceState.isAnalyzing 
                  ? DesertColors.primary
                  : voiceState.hasAnalysis
                      ? DesertColors.sageGreen
                      : DesertColors.onSecondary.withValues(alpha: 0.3),
            ),
            child: Icon(
              voiceState.isAnalyzing 
                  ? Icons.psychology
                  : voiceState.hasAnalysis
                      ? Icons.lightbulb
                      : Icons.lightbulb_outline,
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
                  voiceState.isAnalyzing 
                      ? 'Understanding your emotions...'
                      : voiceState.hasAnalysis
                          ? 'Emotional Insights'
                          : 'AI Analysis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.onSurface,
                  ),
                ),
                if (voiceState.isAnalyzing)
                  Text(
                    'Finding patterns and insights',
                    style: TextStyle(
                      fontSize: 12,
                      color: DesertColors.onSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (voiceState.hasAnalysis && !voiceState.isAnalyzing)
            _buildHeaderActions(voiceState),
        ],
      ),
    );
  }

  Widget _buildHeaderActions(VoiceJournalState voiceState) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Confidence indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getConfidenceColor(voiceState.aiAnalysis!.confidence).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${(voiceState.aiAnalysis!.confidence * 100).round()}% confident',
            style: TextStyle(
              fontSize: 11,
              color: _getConfidenceColor(voiceState.aiAnalysis!.confidence),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Regenerate button
        IconButton(
          onPressed: () {
            ref.read(voiceJournalProvider.notifier).regenerateAnalysis();
          },
          icon: Icon(
            Icons.refresh,
            color: DesertColors.primary,
            size: 20,
          ),
          tooltip: 'Regenerate analysis',
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return DesertColors.sageGreen;
    if (confidence >= 0.6) return DesertColors.primary;
    return DesertColors.terracotta;
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      DesertColors.primary.withValues(alpha: 0.2),
                      DesertColors.sageGreen,
                      DesertColors.primary,
                      DesertColors.primary.withValues(alpha: 0.2),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                    transform: GradientRotation(_loadingAnimation.value * 6.28),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: DesertColors.surface,
                    ),
                    child: Icon(
                      Icons.psychology,
                      color: DesertColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Analyzing your emotional patterns...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: DesertColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This thoughtful process helps us understand your feelings better',
            style: TextStyle(
              fontSize: 14,
              color: DesertColors.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisContent(AIAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emotional Tone
          _buildEmotionalToneCard(analysis),
          
          const SizedBox(height: 16),
          
          // Insight
          _buildInsightCard(analysis),
          
          const SizedBox(height: 16),
          
          // Expandable sections
          _buildExpandableContent(analysis),
        ],
      ),
    );
  }

  Widget _buildEmotionalToneCard(AIAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getToneColor(analysis.emotionalTone).withValues(alpha: 0.1),
            _getToneColor(analysis.emotionalTone).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getToneColor(analysis.emotionalTone).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getToneColor(analysis.emotionalTone),
            ),
            child: Icon(
              _getToneIcon(analysis.emotionalTone),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emotional Tone',
                  style: TextStyle(
                    fontSize: 12,
                    color: DesertColors.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  analysis.emotionalTone,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(AIAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesertColors.waterWash.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
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
                Icons.insights,
                color: DesertColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Insight',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: DesertColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            analysis.insight,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: DesertColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableContent(AIAnalysis analysis) {
    return Column(
      children: [
        // Expand/Collapse Button
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: DesertColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isExpanded ? 'Show Less' : 'Show More Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: DesertColors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Expandable Content
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                heightFactor: _expandAnimation.value,
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                // Triggers
                if (analysis.triggers.isNotEmpty)
                  _buildTriggersSection(analysis.triggers),
                
                const SizedBox(height: 16),
                
                // Suggestions
                if (analysis.suggestions.isNotEmpty)
                  _buildSuggestionsSection(analysis.suggestions),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTriggersSection(List<String> triggers) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesertColors.terracotta.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DesertColors.terracotta.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: DesertColors.terracotta,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Potential Triggers',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: DesertColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: triggers.map((trigger) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: DesertColors.terracotta.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                trigger,
                style: TextStyle(
                  fontSize: 12,
                  color: DesertColors.terracotta,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsSection(List<String> suggestions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesertColors.sageGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DesertColors.sageGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates,
                color: DesertColors.sageGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Suggestions for Well-being',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: DesertColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...suggestions.asMap().entries.map((entry) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DesertColors.sageGreen.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: DesertColors.sageGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: DesertColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DesertColors.terracotta.withValues(alpha: 0.2),
            ),
            child: Icon(
              Icons.error_outline,
              size: 30,
              color: DesertColors.terracotta,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Analysis unavailable',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: DesertColors.onSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Don\'t worry - you can still save your entry',
            style: TextStyle(
              fontSize: 14,
              color: DesertColors.onSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
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
              Icons.lightbulb_outline,
              size: 30,
              color: DesertColors.onSecondary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add your voice first',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: DesertColors.onSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI insights will appear here',
            style: TextStyle(
              fontSize: 14,
              color: DesertColors.onSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getToneColor(String tone) {
    if (tone.toLowerCase().contains('positive') || 
        tone.toLowerCase().contains('hopeful') ||
        tone.toLowerCase().contains('joy')) {
      return DesertColors.sageGreen;
    } else if (tone.toLowerCase().contains('negative') || 
               tone.toLowerCase().contains('sad') ||
               tone.toLowerCase().contains('anxious')) {
      return DesertColors.terracotta;
    } else {
      return DesertColors.primary;
    }
  }

  IconData _getToneIcon(String tone) {
    if (tone.toLowerCase().contains('positive') || 
        tone.toLowerCase().contains('hopeful')) {
      return Icons.sentiment_satisfied;
    } else if (tone.toLowerCase().contains('negative') || 
               tone.toLowerCase().contains('sad')) {
      return Icons.sentiment_dissatisfied;
    } else {
      return Icons.sentiment_neutral;
    }
  }
}