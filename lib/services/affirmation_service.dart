import 'dart:math';
import '../models/journal_entry.dart';

class AffirmationService {
  // Mock GPT API call - replace with actual OpenAI integration later
  Future<String> generateAffirmationFromEntry(JournalEntry? entry) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (entry == null) {
      return _getWelcomeAffirmation();
    }
    
    // Analyze the journal entry content and mood for personalized affirmation
    return _generatePersonalizedAffirmation(entry);
  }
  
  String _generatePersonalizedAffirmation(JournalEntry entry) {
    final mood = entry.mood.toLowerCase();
    final text = entry.transcription.toLowerCase();
    
    // Analyze patterns in the journal entry
    if (_containsPattern(text, ['tired', 'exhausted', 'fatigue', 'drained'])) {
      return _getRestAffirmations().getRandomElement();
    } else if (_containsPattern(text, ['anxious', 'worried', 'stress', 'nervous'])) {
      return _getCalmnessAffirmations().getRandomElement();
    } else if (_containsPattern(text, ['sad', 'lonely', 'down', 'depressed'])) {
      return _getUpliftingAffirmations().getRandomElement();
    } else if (_containsPattern(text, ['grateful', 'thankful', 'blessed', 'happy'])) {
      return _getGratitudeAffirmations().getRandomElement();
    } else if (_containsPattern(text, ['challenge', 'difficult', 'struggle', 'hard'])) {
      return _getStrengthAffirmations().getRandomElement();
    }
    
    // Mood-based fallback
    switch (mood) {
      case 'joyful':
      case 'excited':
        return _getJoyfulAffirmations().getRandomElement();
      case 'calm':
      case 'peaceful':
        return _getCalmnessAffirmations().getRandomElement();
      case 'anxious':
      case 'overwhelmed':
        return _getCalmnessAffirmations().getRandomElement();
      case 'sad':
      case 'melancholic':
        return _getUpliftingAffirmations().getRandomElement();
      case 'angry':
      case 'frustrated':
        return _getPatenceAffirmations().getRandomElement();
      default:
        return _getGeneralAffirmations().getRandomElement();
    }
  }
  
  bool _containsPattern(String text, List<String> patterns) {
    return patterns.any((pattern) => text.contains(pattern));
  }
  
  String _getWelcomeAffirmation() {
    final welcomeAffirmations = [
      "Welcome back to your journey of self-discovery. Today holds infinite possibilities for growth and understanding.",
      "Your commitment to reflection shows the strength of your spirit. Trust in your ability to navigate whatever comes your way.",
      "Each new day is a fresh canvas for your thoughts and dreams. You have everything within you to create something beautiful.",
      "Your willingness to explore your inner world is a gift to yourself. Embrace today with curiosity and compassion.",
      "The path of self-reflection you walk shows courage and wisdom. Step forward today knowing you are exactly where you need to be."
    ];
    return welcomeAffirmations.getRandomElement();
  }
  
  List<String> _getRestAffirmations() => [
    "Rest is not a luxury, but a necessity for your growth. Honor your need for restoration today.",
    "Your body and mind have carried you far. Today, give yourself permission to slow down and recharge.",
    "Even the strongest trees bend in the wind. It's okay to rest and gather your strength.",
    "Fatigue is your body's way of asking for care. Listen with compassion and give yourself what you need.",
    "In rest, you find renewal. In stillness, you discover your inner strength."
  ];
  
  List<String> _getCalmnessAffirmations() => [
    "This moment is all you have, and in this moment, you are safe. Breathe deeply and trust in your resilience.",
    "Anxiety is temporary, but your inner strength is permanent. You have weathered every storm so far.",
    "Peace lives within you, even amidst the chaos. Take a deep breath and reconnect with your calm center.",
    "Your worth is not determined by your worries. You are valuable simply for being who you are.",
    "Like clouds passing through the sky, these feelings will pass. You remain steady and strong."
  ];
  
  List<String> _getUpliftingAffirmations() => [
    "Your sensitivity is a superpower, not a weakness. The world needs your tender heart and unique perspective.",
    "Every emotion you feel is valid and temporary. You are not your feelings—you are the observer of them.",
    "Even in sadness, you are growing. Sometimes we need to feel deeply to heal completely.",
    "Your capacity to feel deeply also means your capacity to experience joy is boundless.",
    "This difficult chapter is not your whole story. Brighter pages are still being written."
  ];
  
  List<String> _getGratitudeAffirmations() => [
    "Your grateful heart is a magnet for even more beautiful experiences. Keep shining that light.",
    "The appreciation you feel multiplies the goodness in your life. You are creating a positive cycle.",
    "Your ability to find joy in simple moments is a rare and precious gift. Continue to nurture this blessing.",
    "Gratitude transforms ordinary days into celebrations. Your perspective is creating magic.",
    "The thankfulness in your heart illuminates not just your life, but the lives of everyone around you."
  ];
  
  List<String> _getStrengthAffirmations() => [
    "Challenges are not roadblocks—they are stepping stones to your next level of growth.",
    "Your struggles today are building the strength you'll need for tomorrow's victories.",
    "Diamond forms under pressure, and so does your resilience. You are becoming more precious through this experience.",
    "Every challenge you face is proof that life believes you can handle it. Trust in your capabilities.",
    "Difficult roads often lead to beautiful destinations. Keep walking—your breakthrough is coming."
  ];
  
  List<String> _getJoyfulAffirmations() => [
    "Your joy is infectious and healing. By being happy, you're making the world a brighter place.",
    "The light you carry within you is exactly what the world needs. Continue to let it shine brilliantly.",
    "Your happiness is not selfish—it's essential. You deserve every moment of joy you're experiencing.",
    "Joy is your natural state. When you feel this way, you're aligned with your truest self.",
    "Your enthusiasm and positivity create ripples of goodness that reach farther than you know."
  ];
  
  List<String> _getPatenceAffirmations() => [
    "Your anger shows you care deeply. Channel this passion into positive change and self-compassion.",
    "Strong emotions are signs of a strong spirit. You have the power to transform this energy.",
    "It's okay to feel frustrated—it means you have high standards. Be patient and gentle with yourself.",
    "Your intensity is part of your power. Learning to flow with it, rather than fight it, is your path to peace.",
    "Behind anger often lies hurt or fear. Acknowledge these feelings with kindness and watch them transform."
  ];
  
  List<String> _getGeneralAffirmations() => [
    "You are exactly where you need to be on your unique journey. Trust the process and trust yourself.",
    "Your story is still being written, and you hold the pen. What beautiful chapter will you create today?",
    "Every experience, good or challenging, is shaping you into who you're meant to become.",
    "Your inner wisdom knows the way forward. Listen quietly and trust what you hear.",
    "You are a unique constellation of experiences, dreams, and possibilities. The universe needs exactly what you offer."
  ];
}

extension ListExtensions<T> on List<T> {
  T getRandomElement() {
    final random = Random();
    return this[random.nextInt(length)];
  }
}