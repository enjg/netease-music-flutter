import 'package:get/get.dart';
import '../../data/models/song_model.dart';

/// 全局播放器服务 - 单例
/// 管理播放状态，跨页面共享
class PlayerService extends GetxService {
  // 播放状态
  final isPlaying = false.obs;
  final currentSong = Rx<SongModel?>(null);
  final playlist = <SongModel>[].obs;
  final currentIndex = 0.obs;
  final progress = 0.0.obs;
  final currentTime = 0.obs;  // 秒
  final duration = 0.obs;      // 秒
  final playMode = PlayMode.sequence.obs;

  // 进度模拟
  bool _progressActive = false;

  /// 设置并播放歌曲
  void playSong(SongModel song, {List<SongModel>? list, int index = 0}) {
    currentSong.value = song;
    if (list != null) {
      playlist.assignAll(list);
      currentIndex.value = index;
    }
    duration.value = song.durationSec;
    currentTime.value = 0;
    progress.value = 0;
    isPlaying.value = true;
    _startProgress();
  }

  /// 播放/暂停
  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      _startProgress();
    }
  }

  /// 下一首
  void next() {
    if (playlist.isEmpty) return;
    currentIndex.value = (currentIndex.value + 1) % playlist.length;
    playSong(playlist[currentIndex.value]);
  }

  /// 上一首
  void prev() {
    if (playlist.isEmpty) return;
    currentIndex.value = (currentIndex.value - 1 + playlist.length) % playlist.length;
    playSong(playlist[currentIndex.value]);
  }

  /// 跳转进度
  void seek(double value) {
    progress.value = value;
    currentTime.value = (value * duration.value).round();
  }

  /// 切换播放模式
  void togglePlayMode() {
    final modes = PlayMode.values;
    final nextIndex = (playMode.value.index + 1) % modes.length;
    playMode.value = modes[nextIndex];
  }

  /// 清空播放列表
  void clear() {
    playlist.clear();
    currentSong.value = null;
    isPlaying.value = false;
    progress.value = 0;
    currentTime.value = 0;
    duration.value = 0;
  }

  void _startProgress() {
    if (_progressActive) return;
    _progressActive = true;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!isPlaying.value || currentSong.value == null) {
        _progressActive = false;
        return false;
      }
      currentTime.value++;
      if (currentTime.value >= duration.value) {
        next();
        return false;
      }
      progress.value = currentTime.value / duration.value;
      return true;
    });
  }
}

enum PlayMode {
  sequence,  // 顺序播放
  loop,      // 列表循环
  single,    // 单曲循环
  shuffle,   // 随机播放
}
