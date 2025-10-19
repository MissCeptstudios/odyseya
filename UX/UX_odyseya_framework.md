# 🌞 Odyseya UX Design System — Full Specification (v1.4)

## 🔮 Brand Concept

Odyseya is an emotional journaling app — calm, reflective, and minimalist.

**Core theme:** "Desert calm meets emotional clarity."

Colors, typography, and visual spacing are designed to express peace, warmth, and emotional balance.

---

## 🎨 1. Color Palette

| Name | HEX Code | Usage |
|------|----------|-------|
| **Primary Brown (Bramble)** | `#57351E` | Main text, headers, interface elements |
| **Accent Caramel (Primary Action)** | `#D8A36C` | Primary buttons, active borders |
| **Light Caramel (Secondary)** | `#DBAC80` | Gradient backgrounds, warmth highlights |
| **Highlight Blue (Calm Blue)** | `#C6D9ED` | Active states, emotional highlights |
| **Muted Brown (Tree Branch)** | `#8B7362` | Descriptive text, placeholders |
| **Background Sand (Base)** | `#F9F5F0` | App background |
| **Card White** | `#FFFFFF` | Widget, card, and field backgrounds |
| **Shadow Grey** | `rgba(0,0,0,0.08)` | Subtle shadow under elements |

### Gradients:
- **Desert Dawn:** `#DBAC80 → #FFFFFF`
- **Western Sunrise:** `#D8A36C → #FFFFFF`
- **Arctic Glow:** `#C6D9ED → #FFFFFF`
- **Bramble Depth:** `#57351E (20%) → #FFFFFF (85%)`

All gradients flow toward white with soft, seamless transitions.

---

## ✍️ 2. Typography

**Font:** Inter

### Color Usage:
- **Primary text:** `#57351E`
- **Secondary text:** `#8B7362`
- **Accent:** `#D8A36C`
- **Button text:** `#FFFFFF`

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| **H1 Large** | 32 pt | 600 | "What's on your mind today?" |
| **H1** | 24 pt | 600 | "Today's affirmation", section headers |
| **H2** | 18–20 pt | 600 | Card titles, subsections |
| **Body** | 16 pt | 400 | Main journal text |
| **Body Small** | 14 pt | 400 | Secondary body text |
| **Secondary** | 14 pt | 400 | Subtitles, descriptions |
| **Button** | 16–18 pt | 600 | Button text |
| **Caption** | 12–13 pt | 300 | Hints, metadata, timestamps |

---

## 🔘 3. Buttons

### Primary Button

| State | Background | Text | Border | Shadow |
|-------|------------|------|--------|--------|
| **Default** | `#D8A36C` | `#FFFFFF` | none | `0 4 8 rgba(0,0,0,0.08)` |
| **Hover/Focus** | `#C18E57` | `#FFFFFF` | 2 px white border | `0 4 8 rgba(0,0,0,0.10)` |
| **Disabled** | `rgba(216,163,108,0.4)` | `rgba(255,255,255,0.7)` | none | none |

- 📏 **Height:** 56 px
- 🟤 **Corner Radius:** 24 px
- 🕊️ **Animation:** fade-in/out 200 ms (ease-in-out)

### Functional Button / Keyword Chip

| State | Background | Text | Border | Shadow |
|-------|------------|------|--------|--------|
| **Unselected** | `#FFFFFF` | `#57351E` | 1.5 px `#D8A36C` | `0 2 6 rgba(0,0,0,0.06)` |
| **Selected** | `#C6D9ED` | `#FFFFFF` | 2 px `#FFFFFF` | `0 4 8 rgba(0,0,0,0.08)` |

- 📏 **Radius:** 24 px
- 🎞️ **Animation:** 0.2 s ease-in-out
- ⚙️ **Use:** emotion tags, message style choices, filters

---

## 🏜️ 4. Fields & Cards

| State | Background | Border | Shadow | Description |
|-------|------------|--------|--------|-------------|
| **Inactive** | `#FFFFFF` | none | `0 4 8 rgba(0,0,0,0.08)` | Default state |
| **Active** | `#FFFFFF` | 1.5 px solid `#D8A36C` | `0 4 8 rgba(0,0,0,0.10)` | Selected state |
| **Disabled** | `#F9F5F0` | none | none | Disabled |

- 📏 **Radius:** 24 px
- 📐 **Padding:** 20 px
- 🧠 **Text:** Inter Regular 16 pt
- 🌫️ **Shadow:** soft, diffused, neutral grey

---

## 🧭 5. Bottom Navigation (Bottom Strap)

| State | Color | Description |
|-------|-------|-------------|
| **Inactive Icon** | `#7A4C25` | Warm brown |
| **Active Icon** | `#D8A36C` | Light caramel |
| **Background** | `#FFFFFF` | Clean white |

- 📏 **Height:** 84 px
- 📐 **Top radius:** 24 px
- 💨 **Shadow:** `0 -2 6 rgba(0,0,0,0.04)`

---

## ☁️ 6. Shadows & Elevation

| Level | Value | Usage |
|-------|-------|-------|
| **0** | none | Flat UI |
| **1** | `0 4 8 rgba(0,0,0,0.08)` | Cards, buttons |
| **2** | `0 2 4 rgba(0,0,0,0.10)` | Active elements |
| **3** | `0 -2 6 rgba(0,0,0,0.04)` | Bottom navigation |
| **Modal** | `0 4 12 rgba(0,0,0,0.10)` | Panels, snackbars |

🧘‍♀️ Always soft, subtle, without harsh outlines.

---

## 💫 7. Motion & Interactions

- **Animation duration:** 200–300 ms
- **Easing:** cubic-bezier(0.4, 0, 0.2, 1)
- **Focus / Select:** soft fade + gentle lift
- **Button click:** slight scale 0.98 → 1.0
- **Modal open:** fade + slide-up (ease-out)
- **Toast:** fade-in/out (3 s)

---

## 🧩 8. Core Components

| Component | Description | Status |
|-----------|-------------|--------|
| **PrimaryButton** | main CTA | ✅ |
| **FunctionalButton** | tag / style selector | ✅ |
| **InputCard** | journal field | ✅ |
| **MoodSlider** | emotion selector (gradient track) | ✅ |
| **AffirmationCard** | daily quote card | ✅ |
| **ModalSheet** | bottom option panel | ✅ |
| **Toast/Snackbar** | feedback notification | ✅ |

---

## 🌿 9. Consistency Rules

| Element | Rule |
|---------|------|
| **Corner radius** | 24 px (modal 32 px, toast 16 px) |
| **Grid** | 8 px spacing |
| **Text color** | always `#57351E` or `#8B7362` |
| **Gradients** | always fade toward white |
| **Animations** | calm, smooth transitions |
| **Visual tone** | warm, minimalist, reflective |
| **Whitespace** | generous for balance and breathing room |
| **Icon style** | outline / minimal, pastel tones |

---

## 💭 10. Microinteractions & Behaviors

- Cards and buttons **lift gently** on tap
- Selecting a field adds a thin **#D8A36C border**
- Button press triggers **subtle pulse or scale**
- Toast appears for **3 seconds** at the bottom (fade)
- App maintains **rhythmic calm**: no abrupt transitions

---

## 🧠 11. Claude Code System Prompt

### 🎯 Claude Code Design Enforcement Prompt — Odyseya

**Instruction:**

When creating or updating any screen in the Odyseya app, strictly follow the guidelines in "Odyseya Design System v1.4."

Maintain full consistency across colors, typography, borders, shadows, motion, and components.

**Apply:**

- **Color palette:** Brown `#57351E`, Caramel `#D8A36C`, Blue `#C6D9ED`, White `#FFFFFF`, Muted `#8B7362`
- **Font:** Inter (400, 500, 600)
- **Corner radius:** 24 px (global standard)
- **Shadow:** `0 4 8 rgba(0,0,0,0.08)`
- **Buttons:** caramel-filled (Primary) or white with caramel border (Functional)
- **Active states:** thin `#D8A36C` border + soft shadow
- **Background:** `#F9F5F0`, cards `#FFFFFF`
- **Animations:** smooth 200–300 ms, ease-in-out
- **Whitespace:** generous, calm spacing
- **Bottom navigation:** active icon `#D8A36C`, inactive `#7A4C25`

Every Odyseya screen should feel like part of a **tranquil desert landscape**.

Colors, gradients, and motion must evoke **emotional clarity and warmth**.

---

🔒 **Claude Code must consistently apply these design rules to all components, widgets, and layouts within the Odyseya ecosystem.**
