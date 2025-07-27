import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../constants/colors.dart';
import 'mood_card.dart';

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
    _pageController = PageController(viewportFraction: 0.8);
    
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
    return Column(
      children: [
        SizedBox(
          height: 280,
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
              
              return Transform.scale(
                scale: index == _currentIndex ? 1.0 : 0.9,
                child: MoodCard(
                  mood: mood,
                  isSelected: isSelected,
                  onTap: () => widget.onMoodSelected(mood),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.moods.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: index == _currentIndex ? 24 : 8,
              decoration: BoxDecoration(
                color: index == _currentIndex
                    ? DesertColors.westernSunrise
                    : DesertColors.surface,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}