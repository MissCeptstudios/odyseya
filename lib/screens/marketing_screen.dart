// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/typography.dart';
import '../constants/colors.dart';
import '../widgets/navigation/custom_nav_icons.dart';

class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation for logo (2-3px up/down, 5s loop)
    _floatController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: -3.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 220, left: 32, right: 32, bottom: 24), // Increased from 160 to 220
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  _buildWhyOdyseya(),
                  const SizedBox(height: 32),
                  _buildJourneyCards(),
                  const SizedBox(height: 32),
                  _buildKeyFeatures(),
                  const SizedBox(height: 32),
                  _buildCTASection(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Fixed top branding layer with floating animation
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    DesertColors.creamBeige.withValues(alpha: 0.95),
                    DesertColors.creamBeige.withValues(alpha: 0.9),
                    DesertColors.creamBeige.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/Odyseya_word.png',
                      width: screenWidth * 0.474, // 10% smaller again (0.527 * 0.9)
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🌙 2️⃣ Why Odyseya? (Emotional Purpose Section)
  Widget _buildWhyOdyseya() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Text(
            'Why Odyseya?',
            style: AppTextStyles.quoteText.copyWith(
              color: DesertColors.brownBramble,
              letterSpacing: 0.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95), // Increased from 0.7 to 0.95
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: DesertColors.arcticRain.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Because not everyone has access to therapy - but everyone deserves understanding.',
                  style: AppTextStyles.body.copyWith(
                    color: DesertColors.brownBramble.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Odyseya helps you declutter your mind, slow down your thoughts, and find emotional clarity.',
                  style: AppTextStyles.body.copyWith(
                    color: DesertColors.brownBramble.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🌾 3️⃣ Four Core Journey Cards (Emotional Flow)
  Widget _buildJourneyCards() {
    return Column(
      children: [
        Text(
          'Your Inner Journey Components',
          style: AppTextStyles.h2Large.copyWith(
            fontWeight: FontWeight.w400,
            color: DesertColors.brownBramble,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ..._buildJourneyPhaseCards(),
      ],
    );
  }

  List<Widget> _buildJourneyPhaseCards() {
    final journeyPhases = [
      {
        'iconBuilder': (Color color, double size) => CustomNavIcons.inspire(color, size),
        'title': 'Find Your Calm',
        'description': 'Begin your day grounded and inspired. Gentle affirmations guide you back to inner balance.',
        'delay': 200,
      },
      {
        'iconBuilder': (Color color, double size) => CustomNavIcons.express(color, size),
        'title': 'Express Your Truth',
        'description': 'Speak or write your thoughts - Odyseya listens and transforms emotion into understanding.',
        'delay': 300,
      },
      {
        'iconBuilder': (Color color, double size) => CustomNavIcons.reflect(color, size),
        'title': 'See Your Patterns',
        'description': 'Understand your emotions through gentle AI reflections and insights.',
        'delay': 400,
      },
      {
        'iconBuilder': (Color color, double size) => CustomNavIcons.renew(color, size),
        'title': 'Grow Through Awareness',
        'description': 'Turn reflection into renewal. Track progress and rediscover balance through awareness.',
        'delay': 600,
      },
    ];

    return journeyPhases.asMap().entries.map((entry) {
        final phase = entry.value;

        return TweenAnimationBuilder(
          duration: Duration(milliseconds: phase['delay'] as int),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95), // Increased from 0.7 to 0.95 for more white
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: DesertColors.arcticRain.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: (phase['iconBuilder'] as Widget Function(Color, double))(
                    DesertColors.westernSunrise,
                    48,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  phase['title'] as String,
                  style: AppTextStyles.h2Large.copyWith(
                    fontWeight: FontWeight.w600,
                    color: DesertColors.brownBramble,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  phase['description'] as String,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 15,
                    color: DesertColors.brownBramble.withValues(alpha: 0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList();
  }

  // 💎 4️⃣ Key Features (Blue Icons, Functional Section)
  Widget _buildKeyFeatures() {
    final features = [
      {
        'icon': Icons.mic_none_outlined,
        'title': 'Voice Journaling',
        'description': 'Speak or type your thoughts freely; AI transcribes and listens with empathy.',
      },
      {
        'icon': Icons.lightbulb_outline,
        'title': 'AI Reflections',
        'description': 'Understand your moods, triggers, and recurring patterns.',
      },
      {
        'icon': Icons.event_note_outlined,
        'title': 'Emotional Calendar & Insights',
        'description': 'Visualize how your emotions evolve with time and clarity.',
      },
      {
        'icon': Icons.auto_stories_outlined,
        'title': 'Journal Export',
        'description': 'Turn reflections into a beautifully formatted Odyseya Journal Book (PDF).',
      },
      {
        'icon': Icons.wb_sunny_outlined,
        'title': 'Daily Affirmations',
        'description': 'Start each day with personalized affirmations that guide you back to inner balance.',
      },
    ];

    return Column(
      children: [
        Text(
          'Key Features',
          style: AppTextStyles.h2Large.copyWith(
            fontWeight: FontWeight.w400,
            color: DesertColors.brownBramble,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...features.map((feature) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92), // Increased from 0.6 to 0.92
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.arcticRain.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  feature['icon'] as IconData,
                  size: 32,
                  color: DesertColors.westernSunrise, // Changed from arcticRain (blue) to westernSunrise (warm brown)
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature['title'] as String,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: DesertColors.brownBramble,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        feature['description'] as String,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: DesertColors.brownBramble.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 🌤️ 5️⃣ CTA (Call to Action) Section
  Widget _buildCTASection(BuildContext context) {
    return Column(
      children: [
        // Primary CTA button - Odyseya style
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              context.go('/signup');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesertColors.westernSunrise,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Begin Your Journey'.toUpperCase(),
              style: AppTextStyles.buttonLarge.copyWith(
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Secondary button - Sign in (Functional button style)
        SizedBox(
          width: double.infinity,
          height: 60,
          child: OutlinedButton(
            onPressed: () {
              context.go('/login');
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: DesertColors.brownBramble,
              side: BorderSide(
                color: DesertColors.caramelDrizzle,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Resume Your Journey'.toUpperCase(),
              style: AppTextStyles.buttonLarge.copyWith(
                color: DesertColors.brownBramble,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Enjoy your journey. Every reflection is a step toward renewal.',
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
