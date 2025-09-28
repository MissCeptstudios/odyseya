import 'package:flutter/material.dart';
import '../constants/colors.dart';

class Mood {
  final String id;
  final String emoji;
  final String label;
  final Color color;
  final String description;
  final String? imagePath;

  const Mood({
    required this.id,
    required this.emoji,
    required this.label,
    required this.color,
    required this.description,
    this.imagePath,
  });

  static const List<Mood> defaultMoods = [
    Mood(
      id: 'joyful',
      emoji: '😄',
      label: 'Joyful',
      color: DesertColors.sunsetOrange,
      description: 'Feeling happy and uplifted',
      imagePath: 'assets/images/moods/Joyful.png',
    ),
    Mood(
      id: 'calm',
      emoji: '😌',
      label: 'Calm',
      color: DesertColors.sageGreen,
      description: 'Peaceful and centered',
      imagePath: 'assets/images/moods/Calm.png',
    ),
    Mood(
      id: 'melancholy',
      emoji: '😢',
      label: 'Melancholy',
      color: DesertColors.dustyRose,
      description: 'Feeling a bit down or pensive',
      imagePath: 'assets/images/moods/Melancholy.png',
    ),
    Mood(
      id: 'grateful',
      emoji: '🙏',
      label: 'Grateful',
      color: DesertColors.terracotta,
      description: 'Thankful and appreciative',
      imagePath: 'assets/images/moods/Grateful.png',
    ),
    Mood(
      id: 'lonely',
      emoji: '😔',
      label: 'Lonely',
      color: DesertColors.softLavender,
      description: 'Feeling isolated or disconnected',
      imagePath: 'assets/images/moods/Lonely.png',
    ),
    Mood(
      id: 'anxious',
      emoji: '😰',
      label: 'Anxious',
      color: Color(0xFFE8B4A0),
      description: 'Worried or nervous about something',
      imagePath: 'assets/images/moods/Anxious.png',
    ),
    Mood(
      id: 'loneliness',
      emoji: '💔',
      label: 'Loneliness',
      color: Color(0xFFB8A9C9),
      description: 'Deep feeling of being alone',
      imagePath: 'assets/images/moods/Loneliness.png',
    ),
    Mood(
      id: 'confident',
      emoji: '💪',
      label: 'Confident',
      color: DesertColors.caramelDrizzle,
      description: 'Strong and self-assured',
      imagePath: 'assets/images/moods/Confident.png',
    ),
    Mood(
      id: 'peaceful',
      emoji: '☮️',
      label: 'Peaceful',
      color: DesertColors.skyBlue,
      description: 'Serene and tranquil',
      imagePath: 'assets/images/moods/Peaceful.png',
    ),
    Mood(
      id: 'sad',
      emoji: '😭',
      label: 'Sad',
      color: Color(0xFF9BB5C7),
      description: 'Feeling down or sorrowful',
      imagePath: 'assets/images/moods/Sad.png',
    ),
    Mood(
      id: 'empty',
      emoji: '😶',
      label: 'Empty',
      color: Color(0xFFC7C7C7),
      description: 'Feeling hollow or void',
      imagePath: 'assets/images/moods/Empty.png',
    ),
    Mood(
      id: 'overwhelmed',
      emoji: '😵',
      label: 'Overwhelmed',
      color: Color(0xFFD4A5A5),
      description: 'Too much to handle right now',
      imagePath: 'assets/images/moods/Overwhelmed.png',
    ),
  ];
  
  // Helper method to get mood by string ID
  static Mood fromString(String moodId) {
    try {
      return defaultMoods.firstWhere((mood) => mood.id == moodId);
    } catch (e) {
      // Return default mood if not found
      return defaultMoods.first;
    }
  }
}