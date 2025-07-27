import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/journal_entry.dart';
import '../../models/mood.dart';

class EntryPreviewCard extends StatelessWidget {
  final List<JournalEntry> entries;
  final DateTime selectedDate;

  const EntryPreviewCard({
    super.key,
    required this.entries,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: DesertColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 20,
                  color: DesertColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.onSurface,
                  ),
                ),
                const Spacer(),
                if (entries.length > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: DesertColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${entries.length} entries',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: DesertColors.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Entries List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _buildEntryItem(entry, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryItem(JournalEntry entry, BuildContext context) {
    final mood = Mood.fromString(entry.mood);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mood.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: mood.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mood and Time
          Row(
            children: [
              Text(
                mood.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mood.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: DesertColors.onSurface,
                    ),
                  ),
                  Text(
                    _formatTime(entry.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: DesertColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  if (entry.hasAudio) ...[
                    Icon(
                      Icons.mic_rounded,
                      size: 16,
                      color: DesertColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.displayDuration,
                      style: TextStyle(
                        fontSize: 12,
                        color: DesertColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (entry.hasAIAnalysis)
                    Icon(
                      Icons.psychology_rounded,
                      size: 16,
                      color: DesertColors.sageGreen,
                    ),
                ],
              ),
            ],
          ),

          if (entry.hasTranscription) ...[
            const SizedBox(height: 12),
            // Transcription Preview
            Text(
              _getTranscriptionPreview(entry.transcription),
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: DesertColors.onSurface,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          if (entry.hasAIAnalysis && entry.aiAnalysis!.insight.isNotEmpty) ...[
            const SizedBox(height: 12),
            // AI Insight Preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DesertColors.sageGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: DesertColors.sageGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.aiAnalysis!.insight,
                      style: TextStyle(
                        fontSize: 13,
                        color: DesertColors.sageGreen,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Tap to view full entry
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // TODO: Navigate to full entry view
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Full entry view coming soon!'),
                  backgroundColor: DesertColors.primary,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Tap to view full entry',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: DesertColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (dateOnly.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else {
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _getTranscriptionPreview(String transcription) {
    if (transcription.length <= 150) {
      return transcription;
    }
    
    // Find a good break point near 150 characters
    final cutoff = transcription.substring(0, 150);
    final lastSpace = cutoff.lastIndexOf(' ');
    
    if (lastSpace > 100) {
      return '${transcription.substring(0, lastSpace)}...';
    } else {
      return '${transcription.substring(0, 147)}...';
    }
  }
}