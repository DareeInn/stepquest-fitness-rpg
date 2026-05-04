import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/achievement.dart';
import '../models/player_stats.dart';

class AchievementService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>>? _achievementCollection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return _db.collection('users').doc(user.uid).collection('achievements');
  }

  static Stream<List<Achievement>> watchAchievements() {
    final achievementsRef = _achievementCollection();

    if (achievementsRef == null) {
      return Stream.value([]);
    }

    return achievementsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Achievement.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  static Future<void> unlockAchievement({
    required String id,
    required String title,
    required String description,
  }) async {
    final achievementsRef = _achievementCollection();
    if (achievementsRef == null) return;

    final achievementRef = achievementsRef.doc(id);
    final snapshot = await achievementRef.get();

    if (snapshot.exists) return;

    await achievementRef.set({
      'title': title,
      'description': description,
      'unlockedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> checkAndUnlock(PlayerStats player) async {
    if (player.battlesWon >= 1) {
      await unlockAchievement(
        id: 'first_battle_won',
        title: 'First Battle Won',
        description: 'Win your first battle.',
      );
    }

    if (player.level >= 5) {
      await unlockAchievement(
        id: 'level_5_reached',
        title: 'Level 5 Reached',
        description: 'Reach level 5.',
      );
    }

    if (player.stepsToday >= 10000 || player.totalSteps >= 10000) {
      await unlockAchievement(
        id: 'ten_thousand_steps',
        title: '10,000 Steps Completed',
        description: 'Complete 10,000 steps.',
      );
    }

    if (player.streakDays >= 3) {
      await unlockAchievement(
        id: 'three_day_streak',
        title: '3-Day Streak',
        description: 'Keep a 3-day streak.',
      );
    }

    if (player.streakDays >= 7) {
      await unlockAchievement(
        id: 'seven_day_streak',
        title: '7-Day Streak',
        description: 'Keep a 7-day streak.',
      );
    }
  }
}