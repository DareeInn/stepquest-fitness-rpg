import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    StepQuestAudioService.playTrack(MusicTrack.intro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.shield, size: 70, color: Colors.greenAccent),
                  const SizedBox(height: 16),
                  const Text(
                    'StepQuest',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Turn your steps into an RPG adventure.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 36),
                  /*_inputField('Email', Icons.email),
                  const SizedBox(height: 14),
                  _inputField('Password', Icons.lock, obscureText: true),
                  const SizedBox(height: 24),*/
                  SizedBox(
                    width: double.infinity,
                    /*child: ElevatedButton(
                      onPressed: () async {
                        await StepQuestAudioService.playTrack(
                          MusicTrack.dashboard,
                        );
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text('Login'),
                    ),*/
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    /*child: OutlinedButton(
                      onPressed: () async {
                        await StepQuestAudioService.playTrack(
                          MusicTrack.dashboard,
                        );
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.greenAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),*/
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final user = await AuthService.signInWithGoogle();

                        if (!context.mounted) return;

                        if (user != null) {
                          await UserProfileService.createProfileIfNeeded(user);
                          await StepQuestAudioService.playTrack(
                            MusicTrack.dashboard,
                          );
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Google Sign-In was cancelled or failed',
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Continue with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  /*const SizedBox(height: 12),
                  TextButton.icon(
                    // DONE: Connect this button to Firebase Google Sign-In.
                    onPressed: () async {
                      final user = await AuthService.signInWithGoogle();

                      if (!context.mounted) return;

                      if (user != null) {
                        await StepQuestAudioService.playTrack(
                          MusicTrack.dashboard,
                        );
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Google Sign-In was cancelled or failed.',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Continue with Google'),
                  ),*/
                  const SizedBox(height: 20),
                  const Text(
                    "Sign in to start your adventure",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFF1A1A27),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
