import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation/top_navigation_bar.dart';

class ReviewSubmitScreen extends ConsumerStatefulWidget {
  const ReviewSubmitScreen({super.key});

  @override
  ConsumerState<ReviewSubmitScreen> createState() => _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState extends ConsumerState<ReviewSubmitScreen> {
  String? selectedMood;
  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Happy', 'color': Color(0xFFFFD93D)},
    {'emoji': '😢', 'label': 'Sad', 'color': Color(0xFF6BCB77)},
    {'emoji': '😰', 'label': 'Anxious', 'color': Color(0xFFFF6B6B)},
    {'emoji': '😌', 'label': 'Calm', 'color': Color(0xFF4D96FF)},
    {'emoji': '😠', 'label': 'Angry', 'color': Color(0xFFFF9671)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OdyseyaTopNavigationBar(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Background_F.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // How are you feeling?
                      const Text(
                        'How are you feeling?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Mood Selection
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: moods.length,
                          itemBuilder: (context, index) {
                            final mood = moods[index];
                            final isSelected = selectedMood == mood['label'];
                            return GestureDetector(
                              onTap: () => setState(() => selectedMood = mood['label']),
                              child: Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: isSelected
                                      ? Border.all(
                                          color: mood['color'],
                                          width: 3,
                                        )
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      mood['emoji'],
                                      style: const TextStyle(fontSize: 36),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      mood['label'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? const Color(0xFF2B7A9E)
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Your Entry Preview
                      const Text(
                        'Your Entry',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.mic,
                                  color: Color(0xFF2B8AB8),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Voice Recording',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2B7A9E),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Duration: 00:45',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF8B7355),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap to play and review your recording',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8B7355),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: selectedMood != null ? _handleSubmit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B8AB8),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            shadowColor: Colors.black.withValues(alpha: 0.3),
                          ),
                          child: const Text(
                            'Submit Entry',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    // TODO: Save entry to database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journal entry saved successfully!'),
        backgroundColor: Color(0xFF2B8AB8),
      ),
    );

    // Navigate back to home/calendar
    context.go('/calendar');
  }
}
