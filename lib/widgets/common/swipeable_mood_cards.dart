import 'package:flutter/material.dart';
import '../../models/mood.dart';
import 'mood_card.dart';
import '../../constants/typography.dart';

class SwipeableMoodCards extends StatefulWidget {
  final List<Mood> moods;
  final Function(Mood) onMoodSelected;
  final Mood? selectedMood;

  const SwipeableMoodCards({
    super.key,
    required this.moods,
    required this.onMoodSelected,
    this.selectedMood,
  });

  @override
  State<SwipeableMoodCards> createState() => _SwipeableMoodCardsState();
}

class _SwipeableMoodCardsState extends State<SwipeableMoodCards> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);

    if (widget.selectedMood != null) {
      final selectedIndex = widget.moods.indexWhere(
        (mood) => mood.id == widget.selectedMood!.id,
      );
      if (selectedIndex != -1) {
        _currentIndex = selectedIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pageController.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Reserve space for dots and spacing
        final dotsHeight = 50.0; // Height for dots and spacing
        final availableHeight = constraints.maxHeight;
        // Ensure we have positive height for PageView
        final pageViewHeight = availableHeight > dotsHeight
            ? availableHeight - dotsHeight
            : availableHeight * 0.85;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: pageViewHeight > 0 ? pageViewHeight : 300,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.moods.length,
                itemBuilder: (context, index) {
                  final mood = widget.moods[index];
                  final isSelected = widget.selectedMood?.id == mood.id;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    transform: Matrix4.identity()
                      ..scale(index == _currentIndex ? 1.0 : 0.92)
                      ..translate(
                        0.0,
                        index == _currentIndex ? 0.0 : 10.0,
                      ),
                    child: MoodCard(
                      mood: mood,
                      isSelected: isSelected,
                      onTap: () => widget.onMoodSelected(mood),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mood counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '${_currentIndex + 1} of ${widget.moods.length}',
                      style: AppTextStyles.captionSmall.copyWith(color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Dots indicator
                  Row(
                    children: List.generate(
                      widget.moods.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: index == _currentIndex ? 10 : 6,
                        width: index == _currentIndex ? 10 : 6,
                        decoration: BoxDecoration(
                          color: index == _currentIndex
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}