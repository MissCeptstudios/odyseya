// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../constants/spacing.dart';
import '../../providers/affirmation_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/inspiration/week_day_carousel.dart';

class AffirmationScreen extends ConsumerStatefulWidget {
  const AffirmationScreen({super.key});

  @override
  ConsumerState<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends ConsumerState<AffirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _buttonController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));

    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    // Load affirmation and start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(affirmationProvider.notifier).loadTodaysAffirmation();
      _startAnimations();
    });
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 250));
    _scaleController.forward();
  }

  void _onAffirmationLoaded() async {
    await Future.delayed(const Duration(milliseconds: 250));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final affirmationState = ref.watch(affirmationProvider);
    final authState = ref.watch(authStateProvider);
    final userName = authState.user?.displayName ??
                     authState.user?.email?.split('@').first ??
                     'there';

    // Trigger button animation when affirmation loads
    if (affirmationState.affirmation != null &&
        !_buttonController.isAnimating &&
        _buttonController.value == 0) {
      _onAffirmationLoaded();
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
        centerTitle: true,
        title: Text(
          'Hi $userName',
          style: AppTextStyles.h2,
        ),
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
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              // Week Day Carousel
              FadeTransition(
                opacity: _fadeAnimation,
                child: WeekDayCarousel(
                  selectedDayIndex: affirmationState.selectedDayIndex,
                  onDaySelected: (index) {
                    ref.read(affirmationProvider.notifier).selectDay(index);
                  },
                  variant: CarouselColorVariant.brown,
                ),
              ),

              const SizedBox(height: 20),

              // Subtitle
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Here\'s a thought for your day',
                  style: AppTextStyles.secondary,
                ),
              ),

              const SizedBox(height: 24),

              // Affirmation Content Card
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: DesertColors.brownBramble.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top Row: Quote Icon and Star
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quote Icon - Simple, no extra decoration
                            Icon(
                              Icons.format_quote,
                              size: 32,
                              color: DesertColors.sunsetOrange.withValues(alpha: 0.4),
                            ),

                            // Star Favorite Icon
                            IconButton(
                              icon: Icon(
                                affirmationState.isFavourite
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 28,
                              ),
                              color: affirmationState.isFavourite
                                  ? DesertColors.sunsetOrange
                                  : DesertColors.brownBramble.withValues(alpha: 0.5),
                              tooltip: affirmationState.isFavourite
                                  ? 'Remove from favourites'
                                  : 'Add to favourites',
                              onPressed: affirmationState.affirmation != null
                                  ? () => ref.read(affirmationProvider.notifier).toggleFavourite()
                                  : null,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Affirmation Text
                        if (affirmationState.isLoading)
                          Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  DesertColors.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Crafting your personal affirmation...',
                                style: AppTextStyles.secondary.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        else if (affirmationState.error != null)
                          Column(
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 48,
                                color: DesertColors.brownBramble.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Welcome back to your journey of reflection and growth.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge,
                              ),
                            ],
                          )
                        else if (affirmationState.affirmation != null)
                          Text(
                            affirmationState.affirmation!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.quoteText,
                          ),

                        const SizedBox(height: 20),

                        // Subtle attribution
                        if (affirmationState.lastEntry != null)
                          Text(
                            'Based on your recent reflections',
                            style: AppTextStyles.captionSmall.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Continue Button
              FadeTransition(
                opacity: _buttonAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_buttonAnimation),
                  child: SizedBox(
                    width: double.infinity,
                    height: OdyseyaSpacing.buttonHeight,
                    child: ElevatedButton(
                      onPressed: affirmationState.isLoading ? null : _onContinuePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesertColors.westernSunrise,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: DesertColors.surface,
                        disabledForegroundColor: DesertColors.onSurface.withValues(alpha: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CONTINUE',
                            style: AppTextStyles.ctaButtonText,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
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

  void _onContinuePressed() {
    // Clear affirmation state
    ref.read(affirmationProvider.notifier).clearAffirmation();

    // Navigate to mood selection
    context.go('/home');
  }
}
