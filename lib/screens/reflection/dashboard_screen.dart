// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../constants/spacing.dart';

/// Dashboard Screen - Your Journey Overview
/// Displays user's emotional journey, insights, streak, mood trends, and journal highlights
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String objective = "Healing after burnout";
  bool showEditObjective = false;
  bool showExportScreen = false;
  String objectiveDraft = "";
  String insight = "You've mentioned gratitude more often — your tone feels lighter this week.";
  bool isRefreshing = false;
  String timeRange = "Last 30 days";

  final int streakDays = 14;
  final List<int> moodsWeek = [4, 6, 5, 7, 6, 8, 5];
  final String dominantMood = "Calm";

  final List<JournalEntryData> journalEntries = [
    JournalEntryData(
      id: "e1",
      date: "Oct 15, 2025",
      title: "Finding balance",
      summary: "Wrote about letting go of pressure and choosing rituals that ground me.",
      mood: "Calm",
      moodEmoji: "🌿",
      fullText: "Today I noticed that when I slow down, I actually get more done.",
    ),
    JournalEntryData(
      id: "e2",
      date: "Oct 14, 2025",
      title: "Trust & renewal",
      summary: "Reflected on trusting the process and allowing small wins to compound.",
      mood: "Hopeful",
      moodEmoji: "💫",
      fullText: "Even when things feel uncertain, I'm learning to anchor in routines.",
    ),
    JournalEntryData(
      id: "e3",
      date: "Oct 13, 2025",
      title: "Letting go of stress",
      summary: "Explored what I can control vs. what I can release.",
      mood: "Relieved",
      moodEmoji: "🌬️",
      fullText: "Naming what's heavy made it lighter. Breathing helps.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    objectiveDraft = objective;
  }

  @override
  Widget build(BuildContext context) {
    if (showExportScreen) {
      return _buildExportScreen();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: DesertColors.brownBramble,
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(OdyseyaSpacing.md),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                children: [
                  _buildJourneyHeader(),
                  const SizedBox(height: OdyseyaSpacing.md),
                  _buildExportWidget(),
                  const SizedBox(height: OdyseyaSpacing.md),
                  _buildMoodAndStreakCard(),
                  const SizedBox(height: OdyseyaSpacing.md),
                  _buildJournalHighlights(),
                  const SizedBox(height: OdyseyaSpacing.md),
                  _buildInsightsCard(),
                  const SizedBox(height: OdyseyaSpacing.md),
                  _buildRecommendationCard(),
                  const SizedBox(height: OdyseyaSpacing.xl),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
      ),
    );
  }

  Widget _buildJourneyHeader() {
    return GestureDetector(
      onTap: () {
        setState(() => showEditObjective = true);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 60,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'YOUR JOURNEY',
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: DesertColors.brownBramble.withValues(alpha: 0.8),
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: DesertColors.brownBramble.withValues(alpha: 0.4),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  objective,
                  style: AppTextStyles.h3.copyWith(
                    color: DesertColors.brownBramble,
                    height: 1.3,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.eco_rounded,
                  color: DesertColors.sageGreen,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const _Pill(text: 'Focus: Calm'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportWidget() {
    return GestureDetector(
      onTap: () {
        setState(() => showExportScreen = true);
      },
      child: _SectionCard(
        child: Row(
          children: [
            // Icon with background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DesertColors.caramelDrizzle.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.file_download_outlined,
                size: 28,
                color: DesertColors.caramelDrizzle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export Your Journal',
                    style: AppTextStyles.h3.copyWith(
                      color: DesertColors.brownBramble,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Download your reflections as a PDF report',
                    style: AppTextStyles.secondary.copyWith(
                      color: DesertColors.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              color: DesertColors.brownBramble.withValues(alpha: 0.4),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodAndStreakCard() {
    return GestureDetector(
      onTap: () {
        context.go('/calendar');
      },
      child: _SectionCard(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _MiniStat(
                            label: 'Streak',
                            value: '$streakDays days',
                            icon: Icons.local_fire_department_rounded,
                            iconColor: DesertColors.sunsetOrange,
                          ),
                          const SizedBox(width: 16),
                          _MiniStat(
                            label: 'Most frequent mood',
                            value: dominantMood,
                            icon: Icons.spa_rounded,
                            iconColor: DesertColors.sageGreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right,
                  color: DesertColors.brownBramble.withValues(alpha: 0.4),
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Sparkline(points: moodsWeek),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalHighlights() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.go('/calendar');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent reflections',
                  style: AppTextStyles.h3.copyWith(
                    color: DesertColors.brownBramble,
                  ),
                ),
                Row(
                  children: [
                    const _Pill(text: 'Swipe'),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: DesertColors.brownBramble.withValues(alpha: 0.4),
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: journalEntries.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _JournalCard(
                  entry: journalEntries[index],
                  onTap: () {
                    // Navigate to journal calendar view (where entries are displayed)
                    context.go('/calendar');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard() {
    return GestureDetector(
      onTap: () {
        // Navigate to calendar where AI insights are shown in detail
        context.go('/calendar');
      },
      child: _SectionCard(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, DesertColors.backgroundSand],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: DesertColors.caramelDrizzle.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.lightbulb_outline_rounded,
                color: DesertColors.caramelDrizzle,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Journey So Far',
                    style: AppTextStyles.secondary.copyWith(
                      color: DesertColors.brownBramble.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insight,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: DesertColors.brownBramble,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              color: DesertColors.brownBramble.withValues(alpha: 0.4),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return GestureDetector(
      onTap: () {
        // Open a dialog with book recommendation details
        _showBookDetails(context);
      },
      child: _SectionCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DesertColors.sageGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: DesertColors.sageGreen,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book of the Month',
                    style: AppTextStyles.secondary.copyWith(
                      color: DesertColors.brownBramble.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'The Mountain Is You',
                    style: AppTextStyles.h3.copyWith(
                      color: DesertColors.brownBramble,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Chosen to support your healing journey.',
                    style: AppTextStyles.secondary.copyWith(
                      color: DesertColors.brownBramble.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              color: DesertColors.brownBramble.withValues(alpha: 0.4),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportScreen() {
    return Scaffold(
      backgroundColor: DesertColors.backgroundSand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(OdyseyaSpacing.lg),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                DesertColors.caramelDrizzle.withValues(alpha: 0.4),
                                DesertColors.dustyBlue.withValues(alpha: 0.3),
                              ],
                              stops: const [0.0, 0.4, 1.2],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📄 Export Your Journal',
                                style: AppTextStyles.h3.copyWith(
                                  color: DesertColors.brownBramble,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Choose a time period to generate your PDF report.',
                                style: AppTextStyles.secondary.copyWith(
                                  color: DesertColors.brownBramble.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          child: _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Time Period',
                                  style: AppTextStyles.secondary.copyWith(
                                    color: DesertColors.brownBramble.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<String>(
                                  value: timeRange,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.black.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: [
                                    'Last 7 days',
                                    'Last 30 days',
                                    'Last 3 months',
                                    'Custom range...'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() => timeRange = newValue!);
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  readOnly: true,
                                  initialValue: 'PDF only',
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.black.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Generating PDF for $timeRange'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: DesertColors.westernSunrise, // #D8A36C westernSunrise
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Text(
                                      'Generate PDF Report'.toUpperCase(),
                                      style: AppTextStyles.buttonLarge.copyWith(
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 60,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() => showExportScreen = false);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: DesertColors.brownBramble,
                                      side: BorderSide(
                                        color: DesertColors.westernSunrise, // #D8A36C
                                        width: 1.5,
                                      ),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      '← Back to Dashboard',
                                      style: AppTextStyles.button.copyWith(
                                        color: DesertColors.brownBramble,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBookDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OdyseyaSpacing.radiusCard),
        ),
        title: Row(
          children: [
            Icon(
              Icons.menu_book,
              color: DesertColors.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Book Recommendation',
                style: AppTextStyles.h3.copyWith(
                  color: DesertColors.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '"The Gifts of Imperfection"',
                style: AppTextStyles.h3.copyWith(
                  color: DesertColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'by Brené Brown',
                style: AppTextStyles.body.copyWith(
                  color: DesertColors.onSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Based on your recent journal entries and emotional patterns, this book explores themes of vulnerability, courage, and self-compassion—which align with your current journey of healing after burnout.',
                style: AppTextStyles.body.copyWith(
                  color: DesertColors.onSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
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
                    Text(
                      'Why this book?',
                      style: AppTextStyles.button.copyWith(
                        color: DesertColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Addresses burnout recovery\n'
                      '• Practical exercises for self-care\n'
                      '• Emphasis on authenticity and belonging\n'
                      '• Aligns with your gratitude practice',
                      style: AppTextStyles.secondary.copyWith(
                        color: DesertColors.onSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTextStyles.button.copyWith(
                color: DesertColors.onSecondary,
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Could open link to bookstore or add to reading list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Book added to your reading list!'),
                    backgroundColor: DesertColors.sageGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Add to List'.toUpperCase(),
                style: AppTextStyles.button.copyWith(
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// REUSABLE WIDGETS
// ============================================================================

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const _SectionCard({
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;

  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyles.buttonSmall.copyWith(
          color: DesertColors.treeBranch,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? DesertColors.sunsetOrange).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor ?? DesertColors.sunsetOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.captionSmall.copyWith(
                        color: DesertColors.brownBramble.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      value,
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: DesertColors.brownBramble,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  final List<int> points;

  const _Sparkline({required this.points});

  @override
  Widget build(BuildContext context) {
    final max = points.isEmpty ? 1 : points.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 60,
      child: Row(
        children: points.map((value) {
          final heightPercent = value / max;
          final opacity = 0.25 + (heightPercent * 0.6);

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: DesertColors.dustyBlue.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(6),
              ),
              height: 60 * heightPercent,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final JournalEntryData entry;
  final VoidCallback onTap;

  const _JournalCard({
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.date,
              style: AppTextStyles.captionSmall.copyWith(
                color: DesertColors.brownBramble.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              entry.title,
              style: AppTextStyles.h3.copyWith(
                color: DesertColors.brownBramble,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              entry.summary,
              style: AppTextStyles.secondary.copyWith(
                color: DesertColors.brownBramble.withValues(alpha: 0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Pill(text: 'Mood: ${entry.moodEmoji} ${entry.mood}'),
                Text(
                  'View →',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: DesertColors.brownBramble.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

class JournalEntryData {
  final String id;
  final String date;
  final String title;
  final String summary;
  final String mood;
  final String moodEmoji;
  final String fullText;

  JournalEntryData({
    required this.id,
    required this.date,
    required this.title,
    required this.summary,
    required this.mood,
    required this.moodEmoji,
    required this.fullText,
  });
}
