import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../services/audio_service.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late final VideoPlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    StepQuestAudioService.playTrack(MusicTrack.intro);
    _controller =
        VideoPlayerController.asset('assets/videos/stepquest_intro.mp4')
          ..initialize().then((_) {
            if (!mounted) return;
            setState(() => _isReady = true);
            _controller.play();
          });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          _controller.value.duration != Duration.zero) {
        _goToLogin();
      }
    });
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _isReady
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(color: Colors.greenAccent),
          ),
          Positioned(
            right: 20,
            top: 50,
            child: TextButton(
              onPressed: _goToLogin,
              child: const Text('Skip', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
