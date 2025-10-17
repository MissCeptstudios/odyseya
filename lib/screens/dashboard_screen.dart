import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../constants/spacing.dart';

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

  String _getRandomInsight() {
    final options = [
      "You've been journaling more consistently — your stability score rose this week.",
      "Gratitude appears 11× this month — your attention is shifting to what nourishes you.",
      "Your tone is calmer on days with voice notes — try a short recording today.",
      "You're trending toward 'hopeful' — keep reinforcing the evening routine."
    ];
    return options[(options.length * 0.5).toInt() % options.length];
  }

  Future<void> _onRefresh() async {
    setState(() => isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      insight = _getRandomInsight();
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showExportScreen) {
      return _buildExportScreen();
    }

    return Scaffold(
      backgroundColor: DesertColors.creamBeige,
      body: SafeArea(
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
    );
  }

  Widget _buildJourneyHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesertColors.creamBeige,
            DesertColors.caramelDrizzle.withOpacity(0.4),
            DesertColors.dustyBlue.withOpacity(0.3),
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR JOURNEY',
            style: OdyseyaTypography.bodySmall.copyWith(
              color: DesertColors.brownBramble.withOpacity(0.8),
              letterSpacing: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$objective 🌿',
            style: OdyseyaTypography.h2.copyWith(
              color: DesertColors.deepBrown,
              fontFamily: 'Lora',
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _OutlinedButton(
                onPressed: () {
                  setState(() => showEditObjective = true);
                },
                text: 'Edit My Journey',
              ),
              const SizedBox(width: 8),
              const _Pill(text: 'Focus: Calm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportWidget() {
    return _SectionCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📤 Export Your Journal',
                  style: OdyseyaTypography.h4.copyWith(
                    color: DesertColors.deepBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Download your reflections as a PDF report.',
                  style: OdyseyaTypography.bodySmall.copyWith(
                    color: DesertColors.deepBrown.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _OutlinedButton(
            onPressed: () {
              setState(() => showExportScreen = true);
            },
            text: 'Export →',
          ),
        ],
      ),
    );
  }

  Widget _buildMoodAndStreakCard() {
    return _SectionCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    _MiniStat(
                      label: 'Streak',
                      value: '$streakDays days',
                      icon: '🔥',
                    ),
                    const SizedBox(width: 16),
                    _MiniStat(
                      label: 'Most frequent mood',
                      value: '🌿 $dominantMood',
                      icon: '🌿',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _OutlinedButton(
                onPressed: isRefreshing ? null : _onRefresh,
                text: isRefreshing ? 'Refreshing…' : 'Refresh',
                backgroundColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Sparkline(points: moodsWeek),
        ],
      ),
    );
  }

  Widget _buildJournalHighlights() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent reflections',
                style: OdyseyaTypography.h4.copyWith(
                  color: DesertColors.deepBrown,
                ),
              ),
              const _Pill(text: 'Swipe'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: journalEntries.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _JournalCard(
                  entry: journalEntries[index],
                  onTap: () {
                    // TODO: Show journal detail
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(journalEntries[index].fullText)),
                    );
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
    return _SectionCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Color(0xFFFFF9F4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌙', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Journey So Far',
                  style: OdyseyaTypography.bodySmall.copyWith(
                    color: DesertColors.deepBrown.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight,
                  style: OdyseyaTypography.bodyMedium.copyWith(
                    color: DesertColors.deepBrown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to full analysis
                  },
                  child: Text(
                    'View full analysis →',
                    style: OdyseyaTypography.bodySmall.copyWith(
                      color: DesertColors.deepBrown.withOpacity(0.9),
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return _SectionCard(
      child: Row(
        children: [
          const Text('📚', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book of the Month',
                  style: OdyseyaTypography.bodySmall.copyWith(
                    color: DesertColors.deepBrown.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'The Mountain Is You',
                  style: OdyseyaTypography.h4.copyWith(
                    color: DesertColors.deepBrown,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Chosen to support your healing journey.',
                  style: OdyseyaTypography.bodySmall.copyWith(
                    color: DesertColors.deepBrown.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _OutlinedButton(
            onPressed: () {
              // TODO: Open book details
            },
            text: 'Read more',
          ),
        ],
      ),
    );
  }

  Widget _buildExportScreen() {
    return Scaffold(
      backgroundColor: DesertColors.creamBeige,
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
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.black.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
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
                                DesertColors.creamBeige,
                                DesertColors.caramelDrizzle.withOpacity(0.4),
                                DesertColors.dustyBlue.withOpacity(0.3),
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
                                style: OdyseyaTypography.h3.copyWith(
                                  color: DesertColors.deepBrown,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Choose a time period to generate your PDF report.',
                                style: OdyseyaTypography.bodySmall.copyWith(
                                  color: DesertColors.deepBrown.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: DesertColors.creamBeige,
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
                                  style: OdyseyaTypography.bodySmall.copyWith(
                                    color: DesertColors.deepBrown.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<String>(
                                  value: timeRange,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.1),
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
                                        color: Colors.black.withOpacity(0.1),
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
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Generating PDF for $timeRange'),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: DesertColors.dustyBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Generate PDF Report'),
                                ),
                                const SizedBox(height: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() => showExportScreen = false);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: DesertColors.deepBrown,
                                    side: BorderSide(
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('← Back to Dashboard'),
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
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
        color: DesertColors.creamBeige,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: OdyseyaTypography.bodySmall.copyWith(
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
  final String icon;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: OdyseyaTypography.bodySmall.copyWith(
                        color: DesertColors.deepBrown.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      value,
                      style: OdyseyaTypography.bodySmall.copyWith(
                        color: DesertColors.deepBrown,
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
      height: 56,
      child: Row(
        children: points.map((value) {
          final heightPercent = value / max;
          final opacity = 0.25 + (heightPercent * 0.6);

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: DesertColors.dustyBlue.withOpacity(opacity),
                borderRadius: BorderRadius.circular(6),
              ),
              height: 56 * heightPercent,
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
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.date,
              style: OdyseyaTypography.bodySmall.copyWith(
                color: DesertColors.deepBrown.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              entry.title,
              style: OdyseyaTypography.h4.copyWith(
                color: DesertColors.deepBrown,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              entry.summary,
              style: OdyseyaTypography.bodySmall.copyWith(
                color: DesertColors.deepBrown.withOpacity(0.9),
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
                  style: OdyseyaTypography.bodySmall.copyWith(
                    color: DesertColors.deepBrown.withOpacity(0.6),
                    fontSize: 11,
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

class _OutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;

  const _OutlinedButton({
    required this.onPressed,
    required this.text,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: DesertColors.deepBrown,
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: OdyseyaTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(text),
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
