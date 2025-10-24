// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import '../../constants/typography.dart';
import '../../constants/colors.dart';
import '../../constants/spacing.dart';

/// Framework v1.4: Height 84px, Top radius 24px, Active #D8A36C, Inactive #7A4C25
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24), // Framework: 24px top radius
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // Framework: 0.04 opacity
            blurRadius: 6, // Framework: blur 6
            offset: const Offset(0, -2), // Framework: 0 -2 6
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: OdyseyaSpacing.navBarHeight, // Framework: 84px (was 72px)
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                index: 0,
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                context,
                icon: Icons.sentiment_satisfied_alt_outlined,
                label: 'Home',
                index: 1,
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                context,
                icon: Icons.mic_none,
                label: 'Journal',
                index: 2,
                isSelected: currentIndex == 2,
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_today_outlined,
                label: 'Calendar',
                index: 3,
                isSelected: currentIndex == 3,
              ),
              // Settings removed per UX requirements - now in top navigation
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
    // Framework v1.4: Active #D8A36C, Inactive #7A4C25
    final iconColor = isSelected
        ? DesertColors.westernSunrise // Framework: #D8A36C (was caramelDrizzle)
        : DesertColors.warmBrown; // Framework: #7A4C25 (was treeBranch)
    final textColor = isSelected
        ? DesertColors.brownBramble
        : DesertColors.warmBrown; // Framework: #7A4C25

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? DesertColors.creamBeige
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: iconColor,
              ),
              Text(
                label,
                style: (isSelected
                    ? OdyseyaTypography.navActive
                    : OdyseyaTypography.navInactive
                ).copyWith(
                  color: textColor,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
