import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/mood.dart';
import '../../constants/typography.dart';

class StatisticsBar extends StatelessWidget {
  final int streak;
  final double completionRate;
  final int totalEntries;
  final String? mostFrequentMood;

  const StatisticsBar({
    super.key,
    required this.streak,
    required this.completionRate,
    required this.totalEntries,
    this.mostFrequentMood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DesertColors.surfaceVariant,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Streak
          Expanded(
            child: _buildStatItem(
              icon: Icons.local_fire_department_rounded,
              iconColor: DesertColors.sunsetOrange,
              label: 'Streak',
              value: '$streak day${streak != 1 ? 's' : ''}',
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: DesertColors.surfaceVariant,
          ),
          
          // Completion Rate
          Expanded(
            child: _buildStatItem(
              icon: Icons.check_circle_outline_rounded,
              iconColor: DesertColors.sageGreen,
              label: 'This Month',
              value: '${(completionRate * 100).toInt()}%',
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: DesertColors.surfaceVariant,
          ),
          
          // Total Entries
          Expanded(
            child: _buildStatItem(
              icon: Icons.edit_note_rounded,
              iconColor: DesertColors.primary,
              label: 'Entries',
              value: '$totalEntries',
            ),
          ),
          
          if (mostFrequentMood != null) ...[
            Container(
              width: 1,
              height: 40,
              color: DesertColors.surfaceVariant,
            ),
            
            // Most Frequent Mood
            Expanded(
              child: _buildMoodItem(mostFrequentMood!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body.copyWith(color: DesertColors.onSurface),
        ),
        Text(
          label,
          style: AppTextStyles.captionSmall.copyWith(color: DesertColors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildMoodItem(String moodId) {
    final mood = Mood.fromString(moodId);
    
    return Column(
      children: [
        Text(
          mood.emoji,
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 2),
        Text(
          'Top Mood',
          style: AppTextStyles.captionSmall.copyWith(color: DesertColors.onSurfaceVariant),
        ),
      ],
    );
  }
}