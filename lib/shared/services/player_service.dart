import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/song_model.dart';

const String _apiBase = 'http://124.156.194.16:3000';

/// 全局播放器服务 - 单例
/// 管理播放状态，跨页面共享
class PlayerService extends GetxService {
  final Dio _dio = Dio();
  final AudioPlayer _player = AudioPlayer();

  // 播放状态
  final isPlaying = false.obs;
  final currentSong = Rx<SongModel?>(null);
  final playlist = <SongModel>[].obs;
  final currentIndex = 0.obs;
  final progress = 0.0.obs;
  final currentTime = 0.obs; // 秒
  final duration = 0.obs; // 秒
  final playMode = PlayMode.sequence.obs;
  final playlistName = ''.obs;

  // 内部订阅
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _stateSub;

  final _random = Random();

  @override
  void onInit() {
    super.onInit();
    _listenStreams();
  }

  /// 监听 just_audio 的各种流
  void _listenStreams() {
    // 位置流 -> 更新 currentTime / progress
    _positionSub = _player.positionStream.listen((pos) {
      currentTime.value = pos.inSeconds;
      final dur = duration.value;
      if (dur > 0) {
        progress.value = pos.inMilliseconds / (dur * 1000);
      }
    });

    // 时长流 -> 更新 duration
    _durationSub = _player.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur.inSeconds;
      }
    });

    // 播放状态流 -> 更新 isPlaying / 处理播放结束
    _stateSub = _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      // 播放完成时自动切下一首
      if (state.processingState == ProcessingState.completed) {
        _onComplete();
      }
    });
  }

  /// 播放完成时根据播放模式处理
  void _onComplete() {
    switch (playMode.value) {
      case PlayMode.single:
        // 单曲循环：重新播放当前歌曲
        _player.seek(Duration.zero);
        _player.play();
        break;
      case PlayMode.sequence:
        // 顺序播放：播完最后一首停止
        if (currentIndex.value < playlist.length - 1) {
          next();
        } else {
          isPlaying.value = false;
        }
        break;
      case PlayMode.loop:
        // 列表循环
        next();
        break;
      case PlayMode.shuffle:
        // 随机播放
        _playRandom();
        break;
    }
  }

  /// 从 API 获取歌曲播放地址
  /// 先尝试 /song/url，若无结果则回退到 /song/url/v1?level=exhigh
  Future<String?> getSongUrl(int id) async {
    try {
      final resp = await _dio.get(
        '$_apiBase/song/url',
        queryParameters: {'id': id},
      );
      final data = resp.data?['data'] as List?;
      if (data != null && data.isNotEmpty) {
        final url = data[0]['url'] as String?;
        if (url != null && url.isNotEmpty) return url;
      }
    } catch (_) {}

    // 回退: /song/url/v1
    try {
      final resp = await _dio.get(
        '$_apiBase/song/url/v1',
        queryParameters: {'id': id, 'level': 'exhigh'},
      );
      final data = resp.data?['data'] as List?;
      if (data != null && data.isNotEmpty) {
        final url = data[0]['url'] as String?;
        if (url != null && url.isNotEmpty) return url;
      }
    } catch (_) {}

    return null;
  }

  /// 设置并播放歌曲
  Future<void> playSong(SongModel song,
      {List<SongModel>? list, int index = 0}) async {
    currentSong.value = song;
    if (list != null) {
      playlist.assignAll(list);
      currentIndex.value = index;
    }

    // 重置进度
    currentTime.value = 0;
    progress.value = 0;
    duration.value = song.durationSec;

    final url = await getSongUrl(song.id);
    if (url == null) {
      // URL 获取失败，尝试跳到下一首
      print('[PlayerService] 无法获取歌曲 ${song.id} 的播放地址，跳过');
      if (playlist.length > 1) {
        next();
      }
      return;
    }

    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      print('[PlayerService] 播放失败: $e');
      if (playlist.length > 1) {
        next();
      }
    }
  }

  /// 播放/暂停
  Future<void> togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      // 如果还没有加载过音频则不播放
      if (currentSong.value != null) {
        await _player.play();
      }
    }
  }

  /// 下一首
  Future<void> next() async {
    if (playlist.isEmpty) return;

    if (playMode.value == PlayMode.shuffle) {
      _playRandom();
      return;
    }

    final nextIdx = (currentIndex.value + 1) % playlist.length;
    currentIndex.value = nextIdx;
    await playSong(playlist[nextIdx]);
  }

  /// 上一首
  Future<void> prev() async {
    if (playlist.isEmpty) return;

    if (playMode.value == PlayMode.shuffle) {
      _playRandom();
      return;
    }

    final prevIdx =
        (currentIndex.value - 1 + playlist.length) % playlist.length;
    currentIndex.value = prevIdx;
    await playSong(playlist[prevIdx]);
  }

  /// 随机播放一首
  Future<void> _playRandom() async {
    if (playlist.isEmpty) return;
    int idx;
    if (playlist.length > 1) {
      do {
        idx = _random.nextInt(playlist.length);
      } while (idx == currentIndex.value);
    } else {
      idx = 0;
    }
    currentIndex.value = idx;
    await playSong(playlist[idx]);
  }

  /// 跳转进度 (value: 0.0 ~ 1.0)
  Future<void> seek(double value) async {
    final dur = _player.duration;
    if (dur == null) return;
    final target = Duration(
      milliseconds: (value * dur.inMilliseconds).round(),
    );
    await _player.seek(target);
    progress.value = value;
    currentTime.value = target.inSeconds;
  }

  /// 跳转到指定秒数
  Future<void> seekToSeconds(int seconds) async {
    await _player.seek(Duration(seconds: seconds));
  }

  /// 切换播放模式
  void togglePlayMode() {
    final modes = PlayMode.values;
    final nextIndex = (playMode.value.index + 1) % modes.length;
    playMode.value = modes[nextIndex];

    // 更新 just_audio 的循环模式（仅影响 single 模式）
    _player.setLoopMode(
      playMode.value == PlayMode.single ? LoopMode.one : LoopMode.off,
    );
  }

  /// 清空播放列表
  Future<void> clear() async {
    await _player.stop();
    playlist.clear();
    currentSong.value = null;
    isPlaying.value = false;
    progress.value = 0;
    currentTime.value = 0;
    duration.value = 0;
  }

  @override
  void onClose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    _dio.close();
    super.onClose();
  }
}

enum PlayMode {
  sequence, // 顺序播放
  loop, // 列表循环
  single, // 单曲循环
  shuffle, // 随机播放
}
