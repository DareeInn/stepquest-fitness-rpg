import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../services/audio_service.dart';
import 'login_screen.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late final VideoPlayerController _controller;

  bool _isReady = false;
  bool _hasError = false;
  bool _hasNavigated = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();

    StepQuestAudioService.playTrack(MusicTrack.intro);

    _controller = VideoPlayerController.asset(
      'assets/videos/stepquest_intro.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _setupVideo();
  }

  Future<void> _setupVideo() async {
    try {
      await _controller.initialize();

      if (!mounted) return;

      await _controller.setLooping(true);
      await _controller.setVolume(0); // video always muted

      setState(() => _isReady = true);

      await _controller.play();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMsg = error.toString();
      });
    }
  }

  void _videoListener() {
    if (!_controller.value.isInitialized || _hasNavigated) return;

    if (_controller.value.hasError) {
      setState(() {
        _hasError = true;
        _errorMsg = _controller.value.errorDescription;
      });
    }
  }

  void _goToLogin() {
    if (!mounted || _hasNavigated) return;

    _hasNavigated = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, __) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('IntroVideoScreen build called');
    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Video failed to load:\n[38;5;2m${_errorMsg ?? 'Unknown error'}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: _isReady
                ? FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.greenAccent),
                  ),
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
