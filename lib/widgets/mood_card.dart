import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/mood.dart';
import '../constants/colors.dart';

class MoodCard extends StatefulWidget {
  final Mood mood;
  final bool isSelected;
  final VoidCallback? onTap;

  const MoodCard({
    super.key,
    required this.mood,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.mood.label} mood card. ${widget.mood.description}',
      selected: widget.isSelected,
      button: true,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onTap?.call();
              },
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: widget.isSelected
                        ? DesertColors.buttonSelectedBorder
                        : DesertColors.buttonUnselectedBorder,
                    width: 2,
                  ),
                  boxShadow: [
                    // Soft ambient shadow
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                    // Premium elevation shadow when selected
                    if (widget.isSelected)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mood Image/Emoji
                    Expanded(
                      flex: 3,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.all(8),
                        transform: Matrix4.identity()..scale(widget.isSelected ? 1.05 : 1.0),
                        child: widget.mood.imagePath != null
                            ? Image.asset(
                                widget.mood.imagePath!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
                                    widget.mood.emoji,
                                    style: const TextStyle(fontSize: 64),
                                  );
                                },
                              )
                            : Text(
                                widget.mood.emoji,
                                style: const TextStyle(fontSize: 64),
                              ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtle selection indicator - minimal dot
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      height: widget.isSelected ? 6 : 0,
                      width: widget.isSelected ? 6 : 0,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: DesertColors.buttonSelectedText,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}