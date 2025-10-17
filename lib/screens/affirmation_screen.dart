import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../providers/affirmation_provider.dart';
import '../widgets/common/app_background.dart';
import '../widgets/navigation/top_navigation_bar.dart';

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
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    
    await Future.delayed(const Duration(milliseconds: 400));
    _scaleController.forward();
  }

  void _onAffirmationLoaded() async {
    await Future.delayed(const Duration(milliseconds: 600));
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
    
    // Trigger button animation when affirmation loads
    if (affirmationState.affirmation != null && !_buttonController.isAnimating && _buttonController.value == 0) {
      _onAffirmationLoaded();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OdyseyaTopNavigationBar(),
            Expanded(
              child: AppBackground(
                useOverlay: true,
                overlayOpacity: 0.05,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                // Header
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/Odyseya_logo.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Good Morning',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: DesertColors.onSurface,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Here\'s a thought for your day',
                        style: TextStyle(
                          fontSize: 16,
                          color: DesertColors.onSurface.withValues(alpha: 0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Affirmation Content
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: DesertColors.shadow.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Quote Icon
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DesertColors.sunsetOrange.withValues(alpha: 0.1),
                            ),
                            child: Icon(
                              Icons.format_quote,
                              size: 28,
                              color: DesertColors.sunsetOrange,
                            ),
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
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: DesertColors.onSurface.withValues(alpha: 0.6),
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
                                  color: DesertColors.onSurface.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Welcome back to your journey of reflection and growth.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 24,
                                    height: 1.4,
                                    color: DesertColors.onSurface,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          else if (affirmationState.affirmation != null)
                            Text(
                              affirmationState.affirmation!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: 24,
                                height: 1.4,
                                color: DesertColors.onSurface,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          
                          const SizedBox(height: 24),
                          
                          // Subtle attribution
                          if (affirmationState.lastEntry != null)
                            Text(
                              'Based on your recent reflections',
                              style: TextStyle(
                                fontSize: 12,
                                color: DesertColors.onSurface.withValues(alpha: 0.5),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

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
                      height: 56,
                      child: ElevatedButton(
                        onPressed: affirmationState.isLoading ? null : _onContinuePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesertColors.caramelDrizzle,
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
                              'Continue to Journal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                      // Skip option
                      FadeTransition(
                        opacity: _buttonAnimation,
                        child: TextButton(
                          onPressed: affirmationState.isLoading ? null : _onContinuePressed,
                          child: Text(
                            'Skip for now',
                            style: TextStyle(
                              fontSize: 14,
                              color: DesertColors.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
    );
  }

  void _onContinuePressed() {
    // Clear affirmation state
    ref.read(affirmationProvider.notifier).clearAffirmation();
    
    // Navigate to mood selection
    context.go('/home');
  }
}