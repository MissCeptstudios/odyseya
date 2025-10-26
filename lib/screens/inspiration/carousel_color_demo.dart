// Demo screen to showcase both color variants of WeekDayCarousel
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../widgets/inspiration/week_day_carousel.dart';

class CarouselColorDemo extends StatefulWidget {
  const CarouselColorDemo({super.key});

  @override
  State<CarouselColorDemo> createState() => _CarouselColorDemoState();
}

class _CarouselColorDemoState extends State<CarouselColorDemo> {
  int _selectedDayBrown = WeekDayCarousel.getTodayIndex();
  int _selectedDayBlue = WeekDayCarousel.getTodayIndex();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesertColors.creamBeige,
      appBar: AppBar(
        title: const Text('Week Day Carousel - Color Variants'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Brown Variant
              const Text(
                'Brown Variant (Desert Theme)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF57351E),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: WeekDayCarousel(
                  selectedDayIndex: _selectedDayBrown,
                  onDaySelected: (index) {
                    setState(() {
                      _selectedDayBrown = index;
                    });
                  },
                  variant: CarouselColorVariant.brown,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Selected: ${WeekDayCarousel.getDayName(_selectedDayBrown)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF57351E),
                ),
              ),

              const SizedBox(height: 48),

              // Blue Variant
              const Text(
                'Blue Variant (Modern Theme)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2196F3),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: WeekDayCarousel(
                  selectedDayIndex: _selectedDayBlue,
                  onDaySelected: (index) {
                    setState(() {
                      _selectedDayBlue = index;
                    });
                  },
                  variant: CarouselColorVariant.blue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Selected: ${WeekDayCarousel.getDayName(_selectedDayBlue)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2196F3),
                ),
              ),

              const Spacer(),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DesertColors.sunsetOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Tap on any day to select it. The selected day will be highlighted with a colored border and shadow effect. The connecting line changes opacity based on the active color.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF57351E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
