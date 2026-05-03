import 'package:just_audio/just_audio.dart';

enum MusicTrack { intro, dashboard, battle }

class StepQuestAudioService {
  StepQuestAudioService._();

  static final AudioPlayer _player = AudioPlayer();

  static double volume = 1.0;
  static bool isMuted = false;
  static MusicTrack? _currentTrack;

  static String _assetForTrack(MusicTrack track) {
    switch (track) {
      case MusicTrack.intro:
        return 'assets/audio/stepquest_theme.mp3';
      case MusicTrack.dashboard:
        return 'assets/audio/dashboard_theme.mp3';
      case MusicTrack.battle:
        return 'assets/audio/battle_theme.mp3';
    }
  }

  static Future<void> playTrack(
    MusicTrack track, {
    bool forceRestart = false,
  }) async {
    if (_currentTrack == track && !forceRestart) return;

    try {
      _currentTrack = track;
      await _player.stop();
      await _player.setAsset(_assetForTrack(track));
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(isMuted ? 0 : volume);
      await _player.play();
    } catch (error) {
      _currentTrack = null;
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
