import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/player_stats.dart';

class UserProfileService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createProfileIfNeeded(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (snapshot.exists) {
      return;
    }

    await userRef.set({
      'name': user.displayName ?? 'StepQuest Player',
      'email': user.email,
      'avatar': 'default_avatar',
      'level': 1,
      'xp': 0,
      'maxXp': 100,
      'stepsToday': 0,
      'totalSteps': 0,
      'streakDays': 0,
      'battlesWon': 0,
      'achievements': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<PlayerStats?> watchCurrentUserProfile() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return _db.collection('users').doc(user.uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return PlayerStats.fromMap(snapshot.data()!);
    });
  }

  static Future<void> updateXpAndLevel({
    required int xp,
    required int level,
    required int maxXp,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'xp': xp,
      'level': level,
      'maxXp': maxXp,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> incrementBattleWins() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'battlesWon': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateLoginStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = _db.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (!snapshot.exists || snapshot.data() == null) return;

    final data = snapshot.data()!;

    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month}-${today.day}";

    final lastLoginStr = data['lastLoginDate'] as String?;
    int currentStreak = data['currentStreak'] ?? 0;
    int longestStreak = data['longestStreak'] ?? 0;

    if (lastLoginStr == null) {
      currentStreak = 1;
    } else {
      final lastDateParts = lastLoginStr.split('-');
      final lastDate = DateTime(
        int.parse(lastDateParts[0]),
        int.parse(lastDateParts[1]),
        int.parse(lastDateParts[2]),
      );

      final difference = today.difference(lastDate).inDays;

      if (difference == 0) {
        return; // already counted today
      } else if (difference == 1) {
        currentStreak += 1;
      } else {
        currentStreak = 1; // streak reset
      }
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    await userRef.update({
      'lastLoginDate': todayStr,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'streakDays': currentStreak,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<PlayerStats?> getCurrentUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists || doc.data() == null) return null;

    return PlayerStats.fromMap(doc.data()!);
  }
}
