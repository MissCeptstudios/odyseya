import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class OdyseyaBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const OdyseyaBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesertColors.background,
        boxShadow: [
          BoxShadow(
            color: DesertColors.waterWash.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _buildNavItem(
                context,
                icon: Icons.mood,
                label: 'Home',
                index: 0,
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                context,
                icon: Icons.mic,
                label: 'Journal',
                index: 1,
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_today,
                label: 'Calendar',
                index: 2,
                isSelected: currentIndex == 2,
              ),
              _buildNavItem(
                context,
                icon: Icons.settings,
                label: 'Settings',
                index: 3,
                isSelected: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected 
                ? DesertColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: isSelected 
                ? Border.all(
                    color: DesertColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  )
                : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(isSelected ? 4 : 2),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? DesertColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: isSelected ? 26 : 22,
                    color: isSelected 
                      ? DesertColors.primary
                      : DesertColors.onSecondary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: isSelected ? 12 : 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected 
                      ? DesertColors.primary
                      : DesertColors.onSecondary.withValues(alpha: 0.7),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}