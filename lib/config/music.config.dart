import 'package:audioplayers/audioplayers.dart';

class BackgroundMusic {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMusicPlaying = false;

  Future<void> playMusic(String filePath) async {
    if (!_isMusicPlaying) {
      await _audioPlayer.play(AssetSource(filePath));
      _isMusicPlaying = true;
    }
  }

  Future<void> stopMusic() async {
    if (_isMusicPlaying) {
      await _audioPlayer.pause();
      _isMusicPlaying = false;
    }
  }

  bool get isMusicPlaying => _isMusicPlaying;

  void toggleMusic(String filePath) async {
    if (_isMusicPlaying) {
      await stopMusic();
    } else {
      await playMusic(filePath);
    }
  }
}