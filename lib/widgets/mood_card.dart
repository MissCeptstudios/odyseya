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
  bool _isPressed = false;

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
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? widget.mood.color.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.mood.color
                      : Colors.grey.withValues(alpha: 0.2),
                  width: widget.isSelected ? 3 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isSelected
                        ? widget.mood.color.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: widget.isSelected ? 16 : 8,
                    offset: const Offset(0, 4),
                    spreadRadius: widget.isSelected ? 2 : 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mood Image/Emoji
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(8),
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

                  const SizedBox(height: 12),

                  // Mood Label
                  Text(
                    widget.mood.label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: widget.isSelected
                          ? widget.mood.color
                          : DesertColors.onSurface,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  // Mood Description
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.mood.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.isSelected
                            ? widget.mood.color.withValues(alpha: 0.8)
                            : DesertColors.onSurface.withValues(alpha: 0.7),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Selection Indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 4,
                    width: widget.isSelected ? 40 : 0,
                    decoration: BoxDecoration(
                      color: widget.mood.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}