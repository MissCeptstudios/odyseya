import 'package:flutter/material.dart';
import '../constants/colors.dart';

class Mood {
  final String id;
  final String emoji;
  final String label;
  final Color color;
  final String description;

  const Mood({
    required this.id,
    required this.emoji,
    required this.label,
    required this.color,
    required this.description,
  });

  static const List<Mood> defaultMoods = [
    Mood(
      id: 'joyful',
      emoji: '😊',
      label: 'Joyful',
      color: DesertColors.sunsetOrange,
      description: 'Feeling happy and uplifted',
    ),
    Mood(
      id: 'calm',
      emoji: '😌',
      label: 'Calm',
      color: DesertColors.sageGreen,
      description: 'Peaceful and centered',
    ),
    Mood(
      id: 'thoughtful',
      emoji: '🤔',
      label: 'Thoughtful',
      color: DesertColors.softLavender,
      description: 'Reflective and contemplative',
    ),
    Mood(
      id: 'melancholy',
      emoji: '😔',
      label: 'Melancholy',
      color: DesertColors.dustyRose,
      description: 'Feeling a bit down or pensive',
    ),
    Mood(
      id: 'hopeful',
      emoji: '🌅',
      label: 'Hopeful',
      color: DesertColors.skyBlue,
      description: 'Optimistic about what\'s ahead',
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