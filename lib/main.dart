import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/battle_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/intro_video_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/': (context) => const IntroVideoScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/quest': (context) => QuestScreen(),
        '/battle': (context) => BattleScreen(),
        '/profile': (context) => ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
      },
    );
  }
}
