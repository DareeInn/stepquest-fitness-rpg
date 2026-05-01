import 'package:just_audio/just_audio.dart';

class StepQuestAudioService {
  StepQuestAudioService._();

  static final AudioPlayer _player = AudioPlayer();

  static double volume = 0.4;
  static bool isMuted = false;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      await _player.setAsset('assets/audio/stepquest_theme.mp3');
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(volume);
      await _player.play();
      _initialized = true;
    } catch (error) {
      // Prevent audio errors from blocking the app.
      _initialized = false;
    }
  }

  static Future<void> setVolume(double value) async {
    volume = value.clamp(0.0, 1.0);
    isMuted = volume == 0;
    await _player.setVolume(volume);
  }

  static Future<void> toggleMute() async {
    isMuted = !isMuted;
    await _player.setVolume(isMuted ? 0 : volume);
  }
}
