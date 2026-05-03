import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}