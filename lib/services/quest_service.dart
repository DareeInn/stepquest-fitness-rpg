import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/quest.dart';
import '../models/game_state.dart';
import 'user_profile_service.dart';

class QuestService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>>? _questCollection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return _db.collection('users').doc(user.uid).collection('quests');
  }

  static Stream<List<Quest>> watchQuests() {
    final questsRef = _questCollection();

    if (questsRef == null) {
      return Stream.value([]);
    }

    return questsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Quest.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  static Future<void> createStarterQuestsIfNeeded() async {
    final questsRef = _questCollection();
    if (questsRef == null) return;

    final snapshot = await questsRef.limit(1).get();

    if (snapshot.docs.isNotEmpty) return;

    final starterQuests = [
      {
        'title': 'Walk 5,000 steps',
        'goal': 5000,
        'rewardXp': 100,
        'completed': false,
        'claimed': false,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Reach 10,000 steps',
        'goal': 10000,
        'rewardXp': 200,
        'completed': false,
        'claimed': false,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Walk 2,500 steps',
        'goal': 2500,
        'rewardXp': 50,
        'completed': false,
        'claimed': false,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final quest in starterQuests) {
      await questsRef.add(quest);
    }
  }

  static Future<void> claimQuestReward(Quest quest) async {
    final questsRef = _questCollection();
    if (questsRef == null) return;

    if (quest.claimed) return;

    final player = GameState.player;
    int newXp = player.currentXp + quest.rewardXp;
    int newLevel = player.level;
    int maxXp = player.maxXp;

    if (newXp >= maxXp) {
      newXp -= maxXp;
      newLevel++;
      maxXp += 500;
    }

    await UserProfileService.updateXpAndLevel(
      xp: newXp,
      level: newLevel,
      maxXp: maxXp,
    );

    await questsRef.doc(quest.id).update({
      'completed': true,
      'claimed': true,
      'claimedAt': FieldValue.serverTimestamp(),
    });
  }
}