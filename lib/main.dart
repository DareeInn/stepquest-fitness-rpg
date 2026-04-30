import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/battle_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const StepQuestApp());
}

class StepQuestApp extends StatelessWidget {
  const StepQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StepQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/quest': (context) => QuestScreen(),
        '/battle': (context) => BattleScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
