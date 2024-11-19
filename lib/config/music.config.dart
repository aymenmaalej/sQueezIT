import 'package:audioplayers/audioplayers.dart';

class BackgroundMusic {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;

  static Future<void> playMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('assets/beat.mp3'));
    _isPlaying = true;
  }

  static Future<void> stopMusic() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  static bool isPlaying() {
    return _isPlaying;
  }
}
