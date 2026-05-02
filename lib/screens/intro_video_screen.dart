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
    print('IntroVideoScreen initState called');

    StepQuestAudioService.playTrack(MusicTrack.intro);

    _controller = VideoPlayerController.asset(
      'assets/videos/stepquest_intro.mp4',
    );

    _setupVideo();
  }

  Future<void> _setupVideo() async {
    try {
      debugPrint('Initializing video controller...');
      await _controller.initialize();
      debugPrint('Video controller initialized.');

      if (!mounted) return;

      await _controller.setLooping(true); // Loop video
      debugPrint('Looping set to true.');
      await _controller.setVolume(0); // Always mute video audio
      debugPrint('Volume set to 0.');

      setState(() => _isReady = true);
      debugPrint(
        'Video initialized: size=[38;5;2m${_controller.value.size}, duration=${_controller.value.duration}, isInitialized=${_controller.value.isInitialized}',
      );

      await _controller.play();
      debugPrint(
        'Video play() called. isPlaying=${_controller.value.isPlaying}',
      );
      setState(() {});

      _controller.addListener(_videoListener);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMsg = error.toString();
      });
      debugPrint('Video failed to initialize: $error');
    }
  }

  void _videoListener() {
    if (!_controller.value.isInitialized || _hasNavigated) return;
    // Always force video playback if paused
    if (!_controller.value.hasError && !_controller.value.isPlaying) {
      _controller.play();
    }
    if (_controller.value.hasError) {
      setState(() {
        _hasError = true;
        _errorMsg = _controller.value.errorDescription;
      });
      debugPrint(
        'Video controller error: ${_controller.value.errorDescription}',
      );
      return;
    }
    // No auto-navigation
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
                    fit: BoxFit.cover,
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
