import 'package:audioplayers/audioplayers.dart';

/// BGM・効果音管理クラス
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sePlayer = AudioPlayer();
  bool _isBgmEnabled = true;
  bool _isSeEnabled = true;

  /// BGMを再生（ループ）
  Future<void> playBgm(String assetPath) async {
    if (!_isBgmEnabled) return;
    try {
      // AssetSourceはassets/プレフィックスなしで指定
      final path = assetPath.replaceFirst('assets/', '');
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(AssetSource(path));
    } catch (e) {
      // BGMファイルが見つからない場合は無視
      // BGM再生エラー（無視）
    }
  }

  /// BGMを停止
  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  /// 効果音を再生
  Future<void> playSe(String assetPath) async {
    if (!_isSeEnabled) return;
    try {
      // AssetSourceはassets/プレフィックスなしで指定
      final path = assetPath.replaceFirst('assets/', '');
      await _sePlayer.play(AssetSource(path));
    } catch (e) {
      // SEファイルが見つからない場合は無視
      // SE再生エラー（無視）
    }
  }

  /// BGMの有効/無効を切り替え
  void setBgmEnabled(bool enabled) {
    _isBgmEnabled = enabled;
    if (!enabled) {
      stopBgm();
    }
  }

  /// 効果音の有効/無効を切り替え
  void setSeEnabled(bool enabled) {
    _isSeEnabled = enabled;
  }

  /// リソースを解放
  void dispose() {
    _bgmPlayer.dispose();
    _sePlayer.dispose();
  }
}
