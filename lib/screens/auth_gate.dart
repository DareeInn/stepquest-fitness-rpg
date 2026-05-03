import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF101018),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          StepQuestAudioService.playTrack(MusicTrack.dashboard);
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}