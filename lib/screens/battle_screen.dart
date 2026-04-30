import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  int playerHp = 100;
  int enemyHp = 100;
  int xpEarned = 0;
  String battleMessage = 'A forest goblin blocks your path!';

  final Random _random = Random();

  void attackEnemy() {
    if (enemyHp <= 0 || playerHp <= 0) return;

    final int playerDamage = 15 + _random.nextInt(16);
    final int enemyDamage = 8 + _random.nextInt(13);

    setState(() {
      enemyHp = max(0, enemyHp - playerDamage);

      if (enemyHp == 0) {
        xpEarned += 200;
        GameState.addXp(200);
        GameState.addBattleWin();
        battleMessage = 'Victory! You defeated the enemy and earned 200 XP.';
        return;
      }

      playerHp = max(0, playerHp - enemyDamage);

      if (playerHp == 0) {
        battleMessage = 'Defeat! Recover and try again after more steps.';
      } else {
        battleMessage =
            'You dealt $playerDamage damage. Enemy dealt $enemyDamage damage.';
      }
    });
  }

  void specialMove() {
    if (enemyHp <= 0 || playerHp <= 0) return;

    setState(() {
      enemyHp = max(0, enemyHp - 35);

      if (enemyHp == 0) {
        xpEarned += 250;
        GameState.addXp(250);
        GameState.addBattleWin();
        battleMessage = 'Special move finished the enemy! +250 XP earned.';
      } else {
        battleMessage = 'You used Step Strike and dealt 35 damage!';
      }
    });
  }

  void resetBattle() {
    setState(() {
      playerHp = 100;
      enemyHp = 100;
      xpEarned = 0;
      battleMessage = 'A forest goblin blocks your path!';
    });
  }

  double hpPercent(int hp) => hp / 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101018),
        title: const Text('Battle Arena'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            _fighterCard(
              name: 'Forest Goblin',
              icon: Icons.cruelty_free,
              hp: enemyHp,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'VS',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            _fighterCard(
              name: 'Level 5 Warrior',
              icon: Icons.shield,
              hp: playerHp,
              color: Colors.greenAccent,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A27),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                battleMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'XP Earned: $xpEarned',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.amberAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: attackEnemy,
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Attack'),
                    style: _buttonStyle(Colors.greenAccent),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: specialMove,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Step Strike'),
                    style: _buttonStyle(Colors.purpleAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: resetBattle,
              child: const Text('Reset Battle'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fighterCard({
    required String name,
    required IconData icon,
    required int hp,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A27),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 46),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: hpPercent(hp).clamp(0.0, 1.0),
            minHeight: 12,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 8),
          Text('$hp / 100 HP'),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }
}
