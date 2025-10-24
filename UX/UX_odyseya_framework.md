🏜️ Odyseya UI Design System — v2.0 (Production Guide)
“Soft motion, pastel shadows, no clutter, no rush.”
Visual identity for the emotional journaling app Odyseya — calm, poetic, and desert-inspired.
🔮 1. Brand Essence
Odyseya is a calm, reflective, minimalist emotional journaling app — a poetic desert journey guided by inner direction.
Everything in the UI should feel slow, warm, and intentional.
Core Flow: Inspiration → Action → Reflection → Renewal
Core Theme: “Desert calm meets emotional clarity.”
🎨 2. Color Palette (Finalized)
Name	HEX	Description	Usage
Brown Bramble	#57351E	Deep grounding brown	Titles, active icons
Tree Branch	#8B7362	Muted brown	Secondary text
Western Sunrise	#D8A36C	Warm golden brown	Buttons, accents
Caramel Drizzle	#DBAC80	Light sandy caramel	Gradients, warmth
Arctic Rain	#C6D9ED	Soft sky blue	Calm contrast color
Water Wash	#AAC6E5	Misty blue	Accent backgrounds
Light Sand	#F9F5F0	Soft beige white	Main app background
Pure White	#FFFFFF	Cards, surfaces	Reading areas
Gradients
Desert Dawn: #DBAC80 → #FFFFFF
Western Sunrise: #D8A36C → #FFFFFF
Arctic Glow: #C6D9ED → #FFFFFF
Always fading toward white for light and calm feel.
✍️ 3. Typography System
Use	Font	Size	Weight	Color
App header (Hi Joanna)	Inter	22–24 pt	600	#57351E
Section Titles (H1)	Inter	24–32 pt	600	#57351E
Body Text	Inter	16 pt	400	#57351E
Secondary Text	Inter	14 pt	400	#8B7362
Captions	Inter	12–13 pt	300	#8B7362
Affirmations / AI Reflections	Cormorant Garamond Italic	26–30 pt	500	#57351E
Affirmation font is poetic, soft, and expressive — never bold or mechanical.
🧭 4. Header & Navigation
Top Header Layout
← Hi, Joanna                                  ⚙️
Font: Inter 24 pt, weight 600
Color: #57351E
Left: Back arrow
Right: Settings (gear icon)
Optional subtitle: “How are you feeling today?”
Bottom Navigation Bar
Tab	Icon	Label	Description
🌅 Inspiration	Light bulb / sunrise	Affirmation screen	Poetic daily quote
✏️ Action	Pen / mic	Journal + Mood	Write, record, or upload
📊 Reflection	Chart / calendar	Calendar & Insights	Mood tracking
🌿 Renewal	Leaf / spark	Self-helper	Breathing, manifestation, letter
Behavior:
State	Icon color
Inactive	#D8A36C (Western Sunrise)
Active	#57351E (Brown Bramble)
Background: white
Top radius: 24 px
Height: 84 px
Shadow: 0 -2 6 rgba(0,0,0,0.05)
Transition: fade 250 ms
🪶 5. Logo Specifications
Use	File	Size	Notes
Main Logo (Splash)	Odyseya.png	width 220 px	Centered hero logo
Compact Logo (AppBar)	Just_compass.png	width 48 px	Optional beside title
App Icon	Compass.png	512×512	Store / launcher
Maintain 16 px margin from screen edges.
🌅 6. Background Logic
Visual Modes
Type	Use	Background
Calm (emotional)	Journaling, Reflection, Affirmation	Gradient + Compass overlay
Plain (focused)	GDPR, Onboarding, Settings, Paywall	Flat white
Compass Background Map
Screen	File	Placement	Opacity
Splash	Odyseya.png	Center	0.35
Affirmation	Just_compass.png	Bottom-right	0.25
Journal / Mood	inside_compass.png	Center	0.20
Reflection	Compass.png + background.png	Top-left	0.25
Renewal	Just_compass.png	Bottom-center	0.25
GDPR / Onboarding / Settings	—	White background	—
🧩 7. Corner Radius System
Unified curvature across all UI elements.
Element	Radius
Buttons (all)	16 px
Cards / Fields / Widgets	16 px
Modals / Bottom Sheets (top only)	32 px
Toasts / Snackbars	12 px
Avatars / Photos	circular / 16 px clip
Bottom Navigation (top)	24 px
“If it touches the user’s focus zone, it has a 16 px curvature.”
🔘 8. Components
Component	Spec	Notes
Primary Button	60 px height, 16 px radius, #D8A36C background	Hover: lighter caramel
Functional Button (Chip)	White fill, caramel border, 16 px radius	Selected → Calm Blue
Input Field / Journal Card	White, soft shadow, caramel border on focus	Padding 20 px
Affirmation Card	White with 16 px radius	Poetic font
ModalSheet	32 px top corners	Slide-up motion
Toast	12 px radius	Fades in/out in 3 s
☁️ 9. Shadows & Motion
Element	Shadow	Motion
Cards / Buttons	0 4 8 rgba(0,0,0,0.08)	fade/scale 200 ms
Modals	0 4 12 rgba(0,0,0,0.10)	slide-up 250 ms
Toasts	light soft	fade-in/out 3 s
Compass	slow rotation 10–15°, 10s loop	opacity pulse 0.2–0.3
All transitions use ease-in-out curve (0.4, 0, 0.2, 1).
💭 10. Affirmation & AI Poetic Layer
Affirmation Font
GoogleFonts.cormorantGaramond(
  fontSize: 28,
  fontStyle: FontStyle.italic,
  color: Color(0xFF57351E),
  height: 1.3,
);
AI Reflection ("Odyseya Mirror")
“Your words carry the warmth of calm dunes — a soft echo of understanding.”
Displayed under each journal entry as a poetic insight card.
🧱 11. Layout Constants
Constant	Value
Screen Padding	24 px
Grid Spacing	8 px
Corner Radius (global)	16 px
Modal Radius	32 px
Toast Radius	12 px
Header Height	72 px
Bottom Nav Height	84 px
📅 12. MVP Phases
Phase	Features	Description
MVP1	Splash, Auth, Onboarding, Affirmation, Mood, Journal (voice/text/photo), AI Light, Calendar, Settings	Core journaling experience
MVP2	Self-helper tools (breathing, manifestation, letter to self), weekly AI insights, book suggestions	Deeper renewal features
🪞 13. Emotional UI Summary
Phase	Feeling	Focus
Inspiration	Calm, grounded	Affirmation
Action	Expressive, honest	Journaling
Reflection	Insightful, balanced	Understanding
Renewal	Restorative, hopeful	Healing & growth
🧠 14. Implementation Prompt (Claude / Flutter)
Instruction:
Apply desert gradient background (#DBAC80 → #FFFFFF) or white (for GDPR/onboarding).
Always include top header with greeting, arrow, and settings.
Bottom navigation with 4 tabs — active color #57351E, inactive #D8A36C.
All corners 16 px, modals 32 px top, toasts 12 px.
Affirmations and AI reflections must use Cormorant Garamond Italic.
Font colors and shadows must match the palette above.
Motions smooth and poetic — never abrupt.
✅ Final Rule
Every screen in Odyseya should feel like a breath.
The white cards float gently on desert gradients.
The compass turns slowly, reminding the user of direction.
The corners curve softly, as if shaped by wind.
And every word — whether written or spoken — rests in calm, golden light.