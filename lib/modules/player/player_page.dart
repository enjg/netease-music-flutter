import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers/song_provider.dart';
import '../../shared/services/player_service.dart';
import '../comment/comment_page.dart';
import 'player_controller.dart';

/// LRC歌词行
class _LyricLine {
  final double time; // 秒
  final String text;
  const _LyricLine(this.time, this.text);
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryAnim;
  bool _showLyrics = false;
  List<_LyricLine> _lyrics = [];
  int _currentLyricIndex = 0;
  String _lastCoverUrl = '';
  int _lastLyricSongId = 0;
  final ScrollController _lyricScrollCtrl = ScrollController();
  List<Color> _ambientColors = const [
    Color(0xFF1a0a2e), Color(0xFF2d1b69), Color(0xFF0f3460), Color(0xFF16213e),
  ];

  @override
  void initState() {
    super.initState();
    _entryAnim = AnimationController(
      duration: const Duration(milliseconds: 1200), vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _entryAnim.dispose();
    _lyricScrollCtrl.dispose();
    super.dispose();
  }

  /// 真实颜色提取
  Future<void> _extractColors(String coverUrl) async {
    if (coverUrl.isEmpty || coverUrl == _lastCoverUrl) return;
    _lastCoverUrl = coverUrl;
    try {
      final provider = NetworkImage('$coverUrl?param=50x50');
      final stream = provider.resolve(const ImageConfiguration());
      final completer = Completer<ui.Image>();
      late ImageStreamListener listener;
      listener = ImageStreamListener((info, _) {
        completer.complete(info.image);
        stream.removeListener(listener);
      }, onError: (_, __) {
        completer.completeError('fail');
        stream.removeListener(listener);
      });
      stream.addListener(listener);
      final image = await completer.future;
      final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return;
      final pixels = byteData.buffer.asUint8List();
      final Map<String, int> colorCount = {};
      for (int i = 0; i < pixels.length; i += 16) {
        final r = (pixels[i] ~/ 32) * 32;
        final g = (pixels[i + 1] ~/ 32) * 32;
        final b = (pixels[i + 2] ~/ 32) * 32;
        final key = '$r,$g,$b';
        colorCount[key] = (colorCount[key] ?? 0) + 1;
      }
      final sorted = colorCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      Color darken(String key, double f) {
        final p = key.split(',').map(int.parse).toList();
        return Color.fromARGB(255, (p[0]*f).round().clamp(0,255), (p[1]*f).round().clamp(0,255), (p[2]*f).round().clamp(0,255));
      }
      final mainKey = sorted.isNotEmpty ? sorted[0].key : '30,30,60';
      final subKey = sorted.length > 1 ? sorted[1].key : '60,30,80';
      if (mounted) setState(() {
        _ambientColors = [darken(mainKey, 0.4), darken(subKey, 0.5), darken(mainKey, 0.25), darken(mainKey, 0.4)];
      });
      image.dispose();
    } catch (_) {
      final hash = coverUrl.hashCode;
      final hue = (hash % 360).toDouble();
      if (mounted) setState(() {
        _ambientColors = [
          HSLColor.fromAHSL(1, hue, 0.6, 0.08).toColor(),
          HSLColor.fromAHSL(1, (hue+40)%360, 0.5, 0.12).toColor(),
          HSLColor.fromAHSL(1, (hue+120)%360, 0.4, 0.10).toColor(),
          HSLColor.fromAHSL(1, (hue+200)%360, 0.5, 0.08).toColor(),
        ];
      });
    }
  }

  /// 加载歌词（解析LRC时间戳）
  Future<void> _loadLyrics(int songId) async {
    if (songId <= 0 || songId == _lastLyricSongId) return;
    _lastLyricSongId = songId;
    try {
      final lrc = await SongProvider().getLyric(songId);
      if (lrc.isEmpty || !mounted) return;
      final lines = <_LyricLine>[];
      for (final line in lrc.split('\n')) {
        // 支持多个时间戳 [00:01.00][00:05.00]歌词
        final timeMatches = RegExp(r'\[(\d+):(\d+)\.(\d+)\]').allMatches(line);
        if (timeMatches.isEmpty) continue;
        final textMatch = RegExp(r'\]([^\[]*)$').firstMatch(line);
        final text = textMatch?.group(1)?.trim() ?? '';
        if (text.isEmpty) continue;
        for (final m in timeMatches) {
          final min = int.parse(m.group(1)!);
          final sec = int.parse(m.group(2)!);
          final ms = int.parse(m.group(3)!.padRight(2, '0'));
          lines.add(_LyricLine(min * 60.0 + sec + ms / 100.0, text));
        }
      }
      lines.sort((a, b) => a.time.compareTo(b.time));
      if (mounted) setState(() => _lyrics = lines);
    } catch (_) {}
  }

  /// 根据当前播放时间更新歌词索引
  void _updateLyricIndex(double currentSeconds) {
    if (_lyrics.isEmpty) return;
    int idx = 0;
    for (int i = _lyrics.length - 1; i >= 0; i--) {
      if (currentSeconds >= _lyrics[i].time) { idx = i; break; }
    }
    if (idx != _currentLyricIndex && mounted) {
      setState(() => _currentLyricIndex = idx);
      // 滚动到当前歌词，使其在歌词区域垂直居中
      if (_lyricScrollCtrl.hasClients) {
        const itemHeight = 50.0; // 大约每行高度
        final viewportHeight = _lyricScrollCtrl.position.viewportDimension;
        final target = (idx * itemHeight - viewportHeight / 2 + itemHeight / 2)
            .clamp(0.0, _lyricScrollCtrl.position.maxScrollExtent);
        _lyricScrollCtrl.animateTo(target,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<PlayerController>(
        init: Get.find<PlayerController>(),
        builder: (ctrl) {
          return Obx(() {
            final song = ctrl.playerService.currentSong.value;
            if (song == null) {
              return const Center(child: Text('暂无播放', style: TextStyle(color: AppColors.textTertiary)));
            }
            // 切歌时提取颜色+加载歌词
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _extractColors(song.coverUrl);
              _loadLyrics(song.id);
            });
            // 跟随进度更新歌词
            _updateLyricIndex(ctrl.playerService.currentTime.value.toDouble());

            return Stack(children: [
              _AmbientBackground(colors: _ambientColors),
              SafeArea(child: Column(children: [
                _fade(0, _buildTopBar(ctrl)),
                const Spacer(flex: 2),
                _scale(100, _buildVinylArea(ctrl)),
                const Spacer(flex: 1),
                _slide(200, _buildIndicator(ctrl)),
                const SizedBox(height: 10),
                _slide(250, _buildSongInfo(ctrl)),
                const SizedBox(height: 12),
                _slide(300, _buildProgressBar(ctrl)),
                const SizedBox(height: 12),
                _slide(350, _buildControls(ctrl)),
                const SizedBox(height: 12),
                _slide(400, _buildActions()),
                const SizedBox(height: 20),
              ])),
              _ModeToast(mode: ctrl.playerService.playMode.value, show: _showModeToast),
            ]);
          });
        },
      ),
    );
  }

  // ── 入场动画 ──
  Widget _fade(int delay, Widget child) {
    final b = delay / 1200.0;
    return AnimatedBuilder(animation: _entryAnim, builder: (_, __) {
      final t = ((_entryAnim.value - b) / 0.6).clamp(0.0, 1.0);
      return Opacity(opacity: t, child: child);
    });
  }

  Widget _scale(int delay, Widget child) {
    final b = delay / 1200.0;
    return AnimatedBuilder(animation: _entryAnim, builder: (_, __) {
      final t = ((_entryAnim.value - b) / 0.6).clamp(0.0, 1.0);
      final c = Curves.easeOutCubic.transform(t);
      return Opacity(opacity: c, child: Transform.scale(scale: 0.8 + 0.2 * c, child: child));
    });
  }

  Widget _slide(int delay, Widget child) {
    final b = delay / 1200.0;
    return AnimatedBuilder(animation: _entryAnim, builder: (_, __) {
      final t = ((_entryAnim.value - b) / 0.6).clamp(0.0, 1.0);
      final c = Curves.easeOutCubic.transform(t);
      return Opacity(opacity: c, child: Transform.translate(offset: Offset(0, 30 * (1 - c)), child: child));
    });
  }

  // ── 顶栏 ──
  Widget _buildTopBar(PlayerController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(children: [
        _glassBtn(Icons.keyboard_arrow_down_rounded, 40, () => Get.back()),
        const Spacer(),
        Column(children: [
          Text('正在播放', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
            color: AppColors.textTertiary, letterSpacing: 1.5)),
          const SizedBox(height: 3),
          Obx(() {
            final name = ctrl.playerService.playlistName.value;
            return Text(name.isNotEmpty ? name : '播放列表',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary));
          }),
        ]),
        const Spacer(),
        _glassBtn(Icons.more_horiz_rounded, 40, () {
                  final song = ctrl.playerService.currentSong.value;
                  if (song == null) return;
                  Get.bottomSheet(Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 36, height: 4, decoration: BoxDecoration(
                        color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 20),
                      Text(song.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 16),
                      _bottomSheetItem(Icons.playlist_add, '添加到歌单', () { Get.back(); }),
                      _bottomSheetItem(Icons.person_outline, '查看歌手', () { Get.back(); Get.toNamed('/artist', arguments: {'id': song.artistIds.isNotEmpty ? song.artistIds.first : 0}); }),
                      _bottomSheetItem(Icons.album_outlined, '查看专辑', () { Get.back(); Get.toNamed('/album', arguments: {'id': int.tryParse(song.albumId) ?? 0}); }),
                    ]),
                  ));
                }),
      ]),
    );
  }

  // ── 唱片区域（点击切换歌词）──
  Widget _buildVinylArea(PlayerController ctrl) {
    return GestureDetector(
      onTap: () => setState(() => _showLyrics = !_showLyrics),
      onHorizontalDragEnd: (d) {
        final v = d.primaryVelocity ?? 0;
        if (v < -50) ctrl.next(); else if (v > 50) ctrl.prev();
      },
      child: SizedBox(height: 280, child: Stack(alignment: Alignment.center, children: [
        AnimatedOpacity(duration: const Duration(milliseconds: 500),
          opacity: _showLyrics ? 0.0 : 1.0, child: _buildVinylCarousel(ctrl)),
        AnimatedOpacity(duration: const Duration(milliseconds: 500),
          opacity: _showLyrics ? 1.0 : 0.0,
          child: _showLyrics ? _buildLyrics() : const SizedBox.shrink()),
      ])),
    );
  }

  Widget _buildVinylCarousel(PlayerController ctrl) {
    final p = ctrl.playerService;
    final playlist = p.playlist;
    final current = p.currentIndex.value;
    final isPlaying = p.isPlaying.value;
    final screenW = MediaQuery.of(context).size.width;

    return Stack(alignment: Alignment.center, children: [
      ...List.generate(playlist.length, (i) {
        final offset = i - current;
        if (offset.abs() > 2) return const SizedBox.shrink();
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          left: screenW / 2 - 130 + offset * 280.0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: i == current ? 1.0 : 0.3,
            child: _VinylDisc(coverUrl: playlist[i].coverUrl, isPlaying: i == current && isPlaying),
          ),
        );
      }),
      _Tonearm(isPlaying: isPlaying),
    ]);
  }

  Widget _buildLyrics() {
    if (_lyrics.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('暂无歌词', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.92))),
        const SizedBox(height: 8),
        Text('点击返回唱片', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.28))),
      ]));
    }
    return GestureDetector(
      onTap: () => setState(() => _showLyrics = false),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          // 上下padding = 歌词区域一半高度，确保首尾歌词也能居中
          final halfView = constraints.maxHeight / 2;
          return ListView.builder(
            controller: _lyricScrollCtrl,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: halfView),
            itemCount: _lyrics.length,
            itemBuilder: (_, i) {
              final active = i == _currentLyricIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: active ? 22 : 16,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                    color: active ? Colors.white.withOpacity(0.92) : Colors.white.withOpacity(0.28),
                    height: 2.2,
                  ),
                  child: Text(_lyrics[i].text, textAlign: TextAlign.center),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ── 指示器 ──
  Widget _buildIndicator(PlayerController ctrl) {
    final p = ctrl.playerService;
    final total = p.playlist.length;
    final current = p.currentIndex.value;
    if (total <= 1) return const SizedBox.shrink();
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total.clamp(0, 10), (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6, height: 6,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(3)));
      }));
  }

  // ── 歌曲信息 ──
  Widget _buildSongInfo(PlayerController ctrl) {
    final song = ctrl.playerService.currentSong.value;
    return SizedBox(height: 56, child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(children: [
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24, child: Text(song?.name ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                color: Colors.white, letterSpacing: -0.4, height: 1.2),
              maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(height: 3),
            SizedBox(height: 18, child: Text(song?.artistText ?? '',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        )),
        _glassBtn(Icons.favorite_border_rounded, 40, () async {
                        final song = ctrl.playerService.currentSong.value;
                        if (song == null) return;
                        try {
                          final provider = SongProvider();
                          await provider.like(song.id);
                          Get.showSnackbar(GetSnackBar(
                            message: '已添加到喜欢',
                            duration: const Duration(seconds: 1),
                            backgroundColor: const Color(0xE6222222),
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          ));
                        } catch (_) {}
                      }, color: AppColors.textSecondary),
      ]),
    ));
  }

  // ── 进度条（扁平液态玻璃）──
  Widget _buildProgressBar(PlayerController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _LiquidGlass(
        radius: 20, padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
        child: Obx(() {
          final p = ctrl.playerService;
          final progress = p.progress.value.clamp(0.0, 1.0);
          return Column(mainAxisSize: MainAxisSize.min, children: [
            LayoutBuilder(builder: (ctx, c) {
              return GestureDetector(
                onHorizontalDragUpdate: (d) => ctrl.seek((d.localPosition.dx / c.maxWidth).clamp(0.0, 1.0)),
                onTapDown: (d) => ctrl.seek((d.localPosition.dx / c.maxWidth).clamp(0.0, 1.0)),
                child: SizedBox(height: 16, child: Stack(alignment: Alignment.centerLeft, children: [
                  Container(height: 3, decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2), color: Colors.white.withOpacity(0.08))),
                  FractionallySizedBox(widthFactor: progress,
                    child: Container(height: 3, decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2), color: Colors.white))),
                  FractionallySizedBox(widthFactor: progress,
                    child: Align(alignment: Alignment.centerRight,
                      child: Container(width: 12, height: 12,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 8)])))),
                ])),
              );
            }),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(Formatters.duration(p.currentTime.value),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
              Text(Formatters.duration(p.duration.value),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
            ]),
          ]);
        }),
      ),
    );
  }

  // ── 控制按钮 ──
  Widget _buildControls(PlayerController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _LiquidGlass(radius: 28, padding: const EdgeInsets.all(22),
        child: Obx(() {
          final p = ctrl.playerService;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _glassBtn(_modeIcon(p.playMode.value), 40, () { ctrl.toggleMode(); _flashModeToast(); },
                color: AppColors.textSecondary),
              _glassBtn(Icons.skip_previous_rounded, 48, ctrl.prev),
              GestureDetector(onTap: ctrl.togglePlay,
                child: Container(width: 60, height: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))]),
                  child: Icon(p.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 28, color: Colors.black))),
              _glassBtn(Icons.skip_next_rounded, 48, ctrl.next),
              _glassBtn(Icons.queue_music_rounded, 40, () {
                      final p = ctrl.playerService;
                      Get.bottomSheet(Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(width: 36, height: 4, decoration: BoxDecoration(
                            color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 16),
                          Text('播放队列 (${p.playlist.length}首)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                          const SizedBox(height: 12),
                          SizedBox(height: 300, child: ListView.builder(
                            itemCount: p.playlist.length,
                            itemBuilder: (_, i) {
                              final s = p.playlist[i];
                              final isCurrent = i == p.currentIndex.value;
                              return ListTile(
                                dense: true,
                                leading: isCurrent ? const Icon(Icons.equalizer, color: AppColors.accent, size: 18) : null,
                                title: Text(s.name, style: TextStyle(fontSize: 14, color: isCurrent ? AppColors.accent : Colors.white70)),
                                subtitle: Text(s.artistText, style: TextStyle(fontSize: 12, color: isCurrent ? AppColors.accent.withOpacity(0.6) : Colors.white38)),
                                onTap: () { p.playSong(p.playlist[i], list: p.playlist, index: i); Get.back(); },
                              );
                            },
                          )),
                        ]),
                      ));
                    }, color: AppColors.textSecondary),
            ]),
          );
        }),
      ),
    );
  }

  // ── 底部操作 ──
  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _LiquidGlass(radius: 22, padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _action(Icons.file_download_outlined, '下载'),
          _action(Icons.share_outlined, '分享'),
          _action(Icons.chat_bubble_outline_rounded, '评论'),
        ])),
    );
  }

  Widget _action(IconData icon, String label) {
    return GestureDetector(onTap: () {
      if (label == '评论') {
        final song = Get.find<PlayerService>().currentSong.value;
        if (song != null) Get.to(() => CommentPage(resourceId: song.id, resourceType: 0));
      } else {
        Get.showSnackbar(GetSnackBar(message: '${label}功能开发中', duration: const Duration(seconds: 1), backgroundColor: const Color(0xE6222222), margin: const EdgeInsets.all(16), borderRadius: 12));
      }
    },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
          color: AppColors.textTertiary, letterSpacing: 0.3)),
      ]));
  }

  Widget _glassBtn(IconData icon, double size, VoidCallback? onTap, {Color? color}) {
    return GestureDetector(onTap: onTap,
      child: Container(width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle,
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.04)]),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2)),
            BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 1, offset: const Offset(0, 1)),
          ]),
        child: Icon(icon, size: size * 0.5, color: color ?? Colors.white)));
  }

  bool _showModeToast = false;
  void _flashModeToast() {
    setState(() => _showModeToast = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _showModeToast = false);
    });
  }

  IconData _modeIcon(PlayMode mode) {
    switch (mode) {
      case PlayMode.single: return Icons.repeat_one_rounded;
      case PlayMode.shuffle: return Icons.shuffle_rounded;
      default: return Icons.repeat_rounded;
    }
  }

  static Widget _bottomSheetItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Icon(icon, size: 20, color: Colors.white70),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════
class _ModeToast extends StatelessWidget {
  final PlayMode mode; final bool show;
  const _ModeToast({required this.mode, required this.show});
  @override
  Widget build(BuildContext context) {
    String text; IconData icon;
    switch (mode) {
      case PlayMode.single: text = '单曲循环'; icon = Icons.repeat_one_rounded; break;
      case PlayMode.shuffle: text = '随机播放'; icon = Icons.shuffle_rounded; break;
      default: text = '顺序播放'; icon = Icons.repeat_rounded; break;
    }
    final h = MediaQuery.of(context).size.height;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300), curve: Curves.easeOut,
      top: show ? h / 2 - 50 : h / 2 - 80,
      left: MediaQuery.of(context).size.width / 2 - 70,
      child: AnimatedOpacity(duration: const Duration(milliseconds: 300),
        opacity: show ? 1.0 : 0.0,
        child: Container(width: 140, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.85), borderRadius: BorderRadius.circular(16)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 8),
            Text(text, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7))),
          ]))));
  }
}

// ═══════════════════════════════════════
class _LiquidGlass extends StatelessWidget {
  final Widget child; final double radius; final EdgeInsets padding;
  const _LiquidGlass({required this.child, this.radius = 20, this.padding = EdgeInsets.zero});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.04)]),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4)),
          BoxShadow(color: Colors.white.withOpacity(0.06), blurRadius: 0, spreadRadius: -1, offset: const Offset(0, 1)),
        ]),
      child: ClipRRect(borderRadius: BorderRadius.circular(radius),
        child: Container(padding: padding,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.white.withOpacity(0.18), Colors.white.withOpacity(0.04), Colors.transparent],
              stops: const [0.0, 0.5, 1.0])),
          child: child)));
  }
}

// ═══════════════════════════════════════
// 氛围背景（不旋转，静态渐变+模糊）
// ═══════════════════════════════════════
class _AmbientBackground extends StatelessWidget {
  final List<Color> colors;
  const _AmbientBackground({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center, radius: 1.5,
            colors: [colors[0], colors[1], colors[2], colors[3]],
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3), radius: 1.2,
                colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
// 旋转黑胶唱片
// ═══════════════════════════════════════
class _VinylDisc extends StatefulWidget {
  final String coverUrl; final bool isPlaying;
  const _VinylDisc({required this.coverUrl, required this.isPlaying});
  @override
  State<_VinylDisc> createState() => _VinylDiscState();
}

class _VinylDiscState extends State<_VinylDisc> with SingleTickerProviderStateMixin {
  late AnimationController _spin;
  @override
  void initState() { super.initState(); _spin = AnimationController(duration: const Duration(seconds: 8), vsync: this); if (widget.isPlaying) _spin.repeat(); }
  @override
  void didUpdateWidget(_VinylDisc old) { super.didUpdateWidget(old); widget.isPlaying ? _spin.repeat() : _spin.stop(); }
  @override
  void dispose() { _spin.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    const s = 260.0; const coverSize = 110.0;
    return AnimatedBuilder(animation: _spin, builder: (_, __) => Transform.rotate(
      angle: _spin.value * 2 * pi,
      child: Container(width: s, height: s,
        decoration: BoxDecoration(shape: BoxShape.circle,
          gradient: const RadialGradient(colors: [Color(0xFF1a1a1a), Color(0xFF111111), Color(0xFF1a1a1a), Color(0xFF111111)], stops: [0.0, 0.3, 0.6, 1.0]),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 10))]),
        child: Stack(alignment: Alignment.center, children: [
          Container(width: s * 0.76, height: s * 0.76, decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: RadialGradient(colors: List.generate(20, (i) => i.isEven ? Colors.white.withOpacity(0.02) : Colors.transparent)))),
          Container(width: s * 0.76, height: s * 0.76, decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.06), Colors.transparent, Colors.transparent, Colors.white.withOpacity(0.03)],
              stops: const [0.0, 0.4, 0.6, 1.0]))),
          Container(width: s - 6, height: s - 6, decoration: BoxDecoration(shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF282828), width: 1))),
          Container(width: coverSize + 11, height: coverSize + 11,
            decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF141414),
              boxShadow: [BoxShadow(color: const Color(0xFF808080).withOpacity(0.4), blurRadius: 0, spreadRadius: 1)]),
            child: Center(child: ClipOval(child: SizedBox(width: coverSize, height: coverSize,
              child: widget.coverUrl.isNotEmpty
                ? Image.network('${widget.coverUrl}?param=220x220', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF222222), child: const Icon(Icons.album, size: 40, color: AppColors.textTertiary)))
                : Container(color: const Color(0xFF222222), child: const Icon(Icons.album, size: 40, color: AppColors.textTertiary)))))),
          Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black,
            border: Border.all(color: const Color(0xFF3C3C3C), width: 2))),
        ]))));
  }
}

// ═══════════════════════════════════════
// 唱针
// ═══════════════════════════════════════
class _Tonearm extends StatelessWidget {
  final bool isPlaying;
  const _Tonearm({required this.isPlaying});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.02,
      right: MediaQuery.of(context).size.width * 0.12,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: -60 * pi / 180, end: isPlaying ? -90 * pi / 180 : -60 * pi / 180),
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut,
        builder: (_, angle, __) => Transform.rotate(angle: angle, alignment: Alignment.topRight,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: RadialGradient(center: const Alignment(-0.2, -0.2),
                colors: [const Color(0xFFBBBBBB), const Color(0xFF888888), const Color(0xFF666666)]),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.7), blurRadius: 15, offset: const Offset(0, 4)),
                BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 0, spreadRadius: -2, offset: const Offset(0, -2)),
              ])),
            Transform.translate(offset: const Offset(-15, -2),
              child: Container(width: 160, height: 4, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                gradient: const LinearGradient(colors: [Color(0xFF999999), Color(0xFFCCCCCC), Color(0xFFEEEEEE), Color(0xFFCCCCCC), Color(0xFF999999)]),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(2, 2))]),
                child: Align(alignment: Alignment.centerLeft,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 14, height: 22, decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2),
                        bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Color(0xFF999999), Color(0xFF777777), Color(0xFF555555)]),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 3))])),
                    Container(width: 3, height: 6, decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2), bottomRight: Radius.circular(2)),
                      color: Color(0xFFAAAAAA))),
                  ])))),
          ]))));
  }
}
