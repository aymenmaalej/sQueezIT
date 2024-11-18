import 'package:audioplayers/audioplayers.dart';

class BackgroundMusic {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;

  static Future<void> playMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('music/barima.mp3')).then((_) {
      _isPlaying = true;
    }).catchError((error) {
      print("Error playing audio: $error");
    });
  }

  static Future<void> stopMusic() async {
    await _audioPlayer.stop().then((_) {
      _isPlaying = false;
    }).catchError((error) {
      print("Error stopping audio: $error");
    });
  }

  static Future<void> pauseMusic() async {
    await _audioPlayer.pause().then((_) {
      _isPlaying = false;
    }).catchError((error) {
      print("Error pausing audio: $error");
    });
  }

  static Future<void> resumeMusic() async {
    await _audioPlayer.resume().then((_) {
      _isPlaying = true;
    }).catchError((error) {
      print("Error resuming audio: $error");
    });
  }

  static bool isPlaying() {
    return _isPlaying;
  }
}
