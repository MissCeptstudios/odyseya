# Odyseya Iconography Guide

**Version 1.0** | Last Updated: October 2025

A complete guide to icon usage and styling for maintaining visual consistency across the Odyseya app.

---

## 🎨 **Icon Style Philosophy**

**Minimalist, Rounded, Emotionally Soft**

Odyseya uses **Material Icons with rounded variants** to maintain:
- Emotional warmth and approachability
- Consistency with the desert-inspired design
- Clear, accessible communication
- Visual harmony with typography

---

## 📐 **Icon Standards**

### **Primary Icon Set**
**Material Icons (Rounded Variants)**
- Use `Icons.name_rounded` or `Icons.name_outlined` variants
- Avoid sharp corners - always prefer rounded versions
- Maintain consistent stroke weight across the app

### **Icon Sizes**

```dart
// Navigation & UI
iconSmall:  16px  // Inline icons, badges
iconMedium: 20px  // Buttons, form fields
iconLarge:  22px  // Navigation bar
iconXLarge: 24px  // Tab bars, headers
iconHuge:   32px  // Feature highlights
iconMoodCard: 64px // Mood selection (emoji/illustrations)
```

### **Icon Colors**

```dart
// Primary States
Active:     DesertColors.westernSunrise  (#D8A36C)
Inactive:   DesertColors.treeBranch      (#8B7362)
Disabled:   DesertColors.taupe @ 30% alpha
On Dark:    Colors.white
On Light:   DesertColors.deepBrown

// Semantic
Success:    DesertColors.sageGreen
Warning:    DesertColors.sunsetOrange
Error:      DesertColors.terracotta
Info:       DesertColors.dustyBlue
```

---

## 🎯 **Icon Usage by Context**

### **Navigation Icons**

```dart
// Bottom Navigation (22px, rounded)
Home:       Icons.sentiment_satisfied_alt_outlined
Journal:    Icons.mic_none_rounded
Calendar:   Icons.calendar_today_outlined
Settings:   Icons.settings_outlined

// Top Navigation
Back:       Icons.arrow_back_rounded
Close:      Icons.close_rounded
Menu:       Icons.menu_rounded
Help:       Icons.help_outline_rounded
```

### **Action Icons**

```dart
// Recording Actions (32-48px)
Record:     Icons.mic_rounded
Pause:      Icons.pause_rounded
Play:       Icons.play_arrow_rounded
Stop:       Icons.stop_rounded
Resume:     Icons.play_arrow_rounded

// Common Actions (20-24px)
Add:        Icons.add_rounded
Edit:       Icons.edit_outlined
Delete:     Icons.delete_outline_rounded
Save:       Icons.check_rounded
Share:      Icons.share_outlined
```

### **Status Icons**

```dart
// Feedback (24px)
Success:    Icons.check_circle_outline_rounded
Error:      Icons.error_outline_rounded
Warning:    Icons.warning_amber_rounded
Info:       Icons.info_outline_rounded

// Premium
Lock:       Icons.lock_rounded
Premium:    Icons.workspace_premium_rounded
```

### **Content Icons**

```dart
// Journal & Notes (20-24px)
Text:       Icons.text_fields_rounded
Voice:      Icons.mic_rounded
Mood:       Icons.sentiment_satisfied_alt_rounded
Insights:   Icons.lightbulb_outline_rounded
Calendar:   Icons.calendar_today_rounded
Time:       Icons.access_time_rounded
```

---

## 🎭 **Icon States & Animations**

### **Interactive States**

```dart
// Default State
- Size: Standard (per context)
- Color: treeBranch or westernSunrise
- Opacity: 1.0

// Hover/Focus (Web)
- Scale: 1.05
- Duration: 150ms
- Curve: easeOutCubic

// Active/Pressed
- Scale: 0.95
- Duration: 150ms
- Color: westernSunrise (brighter)

// Disabled
- Opacity: 0.3
- Color: taupe
- No interaction
```

### **Transition Animations**

```dart
// Icon Change (tab switching)
Duration: 300ms
Curve: easeInOut
Type: Fade + Rotate (45° for transformation)

// Recording Glow
Duration: 1200ms (repeating)
Glow: westernSunrise @ 40% alpha
Blur: 24px
Spread: 10-20px (pulsing)
```

---

## 🔄 **Icon Consistency Rules**

### **DO:**
✅ Use rounded variants (`_rounded`, `_outlined`)
✅ Maintain consistent sizing within sections
✅ Use Western Sunrise for active/primary states
✅ Add appropriate padding (min 48×48px touch target)
✅ Include semantic labels for screen readers
✅ Use icon + text for clarity in navigation
✅ Animate state changes smoothly (300ms)

### **DON'T:**
❌ Mix sharp and rounded icon styles
❌ Use icons smaller than 16px
❌ Use icons without sufficient contrast
❌ Forget touch target minimums (48×48px)
❌ Use icons alone without context for critical actions
❌ Over-animate - keep it subtle and calm
❌ Use custom SVG icons unless absolutely necessary

---

## 📱 **Icon Patterns by Screen**

### **Mood Selection Screen**
- Large emoji/illustrations: 64px
- Grid layout with text labels
- Active border: Western Sunrise
- Haptic feedback on selection

### **Recording Screen**
- Main record button: 160×160px circular
- Recording state: Western Sunrise glow
- Control icons: 32px (pause, stop)
- Timer icon: 24px

### **Calendar Screen**
- Date indicators: 20px
- Mood icons: 32px (in calendar cells)
- Filter icons: 20px
- View switchers: 24px

### **Settings Screen**
- Section icons: 24px
- List item icons: 20px
- Toggle indicators: 24px
- Chevrons: 20px

---

## 🎨 **Icon Customization**

### **When to Add Custom Icons**

Only create custom icons when:
1. Material Icons doesn't have a suitable option
2. Mood/emotion representations need specific illustration
3. Premium branding requires unique styling

### **Custom Icon Guidelines**

If creating custom icons:
```dart
// SVG Export Settings
- Stroke width: 2px (consistent)
- Corner radius: 2-4px (rounded)
- ViewBox: 24×24
- Color: Single color (will be tinted in code)
- Format: SVG, optimized

// Implementation
- Use flutter_svg package
- Apply color via theme
- Size via standard scale (16-64px)
```

---

## 🔍 **Accessibility**

### **Icon Accessibility Checklist**

```dart
// Always include semantic labels
Icon(
  Icons.mic_rounded,
  semanticLabel: 'Start voice recording',
)

// Minimum contrast ratios
- Icon on light background: 3:1 (WCAG AA)
- Icon on dark background: 3:1 (WCAG AA)
- Interactive icons: 4.5:1 recommended

// Touch targets
- Minimum: 48×48px
- Recommended: 56×56px for primary actions
- Icon size can be smaller, but hitbox must meet minimum
```

---

## 📊 **Icon Inventory**

### **Most Commonly Used Icons**

| Icon | Usage | Size | Color |
|------|-------|------|-------|
| `mic_rounded` | Recording, voice journal | 32-48px | Western Sunrise |
| `sentiment_satisfied_alt` | Mood, home nav | 22-64px | Western Sunrise (active) |
| `calendar_today` | Calendar nav, dates | 20-22px | Tree Branch / Western Sunrise |
| `settings` | Settings nav | 22px | Tree Branch / Western Sunrise |
| `arrow_back_rounded` | Navigation back | 24px | Deep Brown / White |
| `check_rounded` | Confirmation, save | 24px | Sage Green |
| `lock_rounded` | Premium features | 16-24px | Rose Sand |
| `lightbulb_outline` | AI insights | 20-24px | Western Sunrise |

---

## 🎯 **Implementation Example**

```dart
// Correct icon implementation
Icon(
  Icons.mic_rounded,  // Rounded variant
  size: OdyseyaSpacing.iconHuge,  // 32px from constants
  color: DesertColors.westernSunrise,  // Emotional peak
  semanticLabel: 'Start recording',  // Accessibility
)

// With touch target wrapper
IconButton(
  icon: Icon(
    Icons.arrow_back_rounded,
    size: OdyseyaSpacing.iconLarge,
  ),
  color: DesertColors.deepBrown,
  iconSize: 24,
  constraints: BoxConstraints(
    minWidth: 48,
    minHeight: 48,
  ),
  onPressed: () => Navigator.pop(context),
  tooltip: 'Go back',
)

// With animation
AnimatedContainer(
  duration: OdyseyaAnimations.fast,
  child: Icon(
    isActive ? Icons.mic_rounded : Icons.mic_none_rounded,
    color: isActive
      ? DesertColors.westernSunrise
      : DesertColors.treeBranch,
    size: OdyseyaSpacing.iconLarge,
  ),
)
```

---

## 📝 **Summary**

**Odyseya Iconography = Rounded + Warm + Consistent**

- **Style:** Material Icons (rounded variants)
- **Active Color:** Western Sunrise (#D8A36C)
- **Inactive Color:** Tree Branch (#8B7362)
- **Sizes:** 16-64px (standardized scale)
- **Animation:** 300ms, easeOutCubic
- **Accessibility:** Always labeled, 48×48px minimum touch

This creates a cohesive, emotionally warm iconography system that complements the desert-inspired design language while maintaining excellent usability and accessibility.

---

**Questions or Additions?**
Refer to `DESIGN_SYSTEM.md` for complete design guidelines.
