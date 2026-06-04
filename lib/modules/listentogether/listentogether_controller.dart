import 'package:get/get.dart';
import '../../data/providers/listentogether_provider.dart';

class ListentogetherController extends GetxController {
  final _provider = ListenTogetherProvider();

  // 状态数据
  final status = Rx<Map<String, dynamic>>({});
  final roomInfo = Rx<Map<String, dynamic>>({});
  final playlist = <Map<String, dynamic>>[].obs;

  // UI 状态
  final isMatching = false.obs;
  final isActive = false.obs;
  final isLoading = false.obs;

  // 房间信息
  final roomId = ''.obs;
  final chatMsg = ''.obs;

  // 心跳定时器
  // Timer? _heartbeatTimer;

  @override
  void onInit() {
    super.onInit();
    checkStatus();
  }

  @override
  void onClose() {
    // _heartbeatTimer?.cancel();
    super.onClose();
  }

  /// 检查一起听状态
  Future<void> checkStatus() async {
    try {
      final data = await _provider.getStatus();
      status.value = Map.from(data['data'] ?? {});
      if (status.value['status'] == 'playing') {
        isActive.value = true;
        isMatching.value = false;
        roomId.value = status.value['roomId'] ?? '';
        // _startHeartbeat();
      }
    } catch (_) {}
  }

  /// 创建房间
  Future<bool> createRoom() async {
    isLoading.value = true;
    try {
      final data = await _provider.createRoom();
      if (data['code'] == 200) {
        roomId.value = data['data']?['roomId'] ?? '';
        isActive.value = true;
        await checkRoom();
        // _startHeartbeat();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 检查房间情况
  Future<void> checkRoom() async {
    if (roomId.value.isEmpty) return;
    try {
      final data = await _provider.checkRoom(roomId: roomId.value);
      roomInfo.value = Map.from(data['data'] ?? {});
    } catch (_) {}
  }

  /// 接受邀请加入房间
  Future<bool> acceptInvite(String roomId, int inviterId) async {
    isLoading.value = true;
    try {
      final data = await _provider.accept(roomId: roomId, inviterId: inviterId);
      if (data['code'] == 200) {
        this.roomId.value = roomId;
        isActive.value = true;
        await checkRoom();
        // _startHeartbeat();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 结束房间
  Future<void> endSession() async {
    if (roomId.value.isEmpty) return;
    try {
      await _provider.endRoom(roomId: roomId.value);
    } catch (_) {}
    // _heartbeatTimer?.cancel();
    isActive.value = false;
    status.value = {};
    roomInfo.value = {};
    roomId.value = '';
  }

  /// 发送心跳
  Future<void> heartbeat({
    required int songId,
    int playStatus = 1,
    int progress = 0,
  }) async {
    if (roomId.value.isEmpty) return;
    try {
      await _provider.heartbeat(
        roomId: roomId.value,
        songId: songId,
        playStatus: playStatus,
        progress: progress,
      );
    } catch (_) {}
  }

  /// 发送播放命令
  Future<void> sendPlayCommand({
    required int commandType,
    int progress = 0,
    int playStatus = 1,
    int? formerSongId,
    int? targetSongId,
  }) async {
    if (roomId.value.isEmpty) return;
    try {
      await _provider.sendPlayCommand(
        roomId: roomId.value,
        commandType: commandType,
        progress: progress,
        playStatus: playStatus,
        formerSongId: formerSongId,
        targetSongId: targetSongId,
      );
    } catch (_) {}
  }

  /// 同步播放列表
  Future<void> syncPlaylist({
    required int commandType,
    required int userId,
    required int version,
    List<int>? randomList,
    List<int>? displayList,
  }) async {
    if (roomId.value.isEmpty) return;
    try {
      await _provider.syncList(
        roomId: roomId.value,
        commandType: commandType,
        userId: userId,
        version: version,
        randomList: randomList,
        displayList: displayList,
      );
    } catch (_) {}
  }

  /// 获取当前播放列表
  Future<void> loadPlaylist() async {
    if (roomId.value.isEmpty) return;
    try {
      final data = await _provider.getPlaylist(roomId: roomId.value);
      playlist.assignAll((data['data']?['tracks'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 切歌
  Future<void> toggleSong() async {
    await sendPlayCommand(commandType: 2);
  }

  /// 暂停/播放
  Future<void> togglePlay({bool isPlaying = true}) async {
    await sendPlayCommand(
      commandType: isPlaying ? 1 : 0,
      playStatus: isPlaying ? 1 : 0,
    );
  }

  /// 发送聊天消息
  Future<void> sendChat(String msg) async {
    chatMsg.value = msg;
    // 实际发送逻辑需要 WebSocket 支持
  }

  // void _startHeartbeat() {
  //   _heartbeatTimer?.cancel();
  //   _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
  //     heartbeat(songId: 0);
  //   });
  // }

  /// 刷新
  Future<void> refresh() async {
    await checkStatus();
    if (isActive.value) {
      await checkRoom();
      await loadPlaylist();
    }
  }

  /// 开始匹配
  Future<void> startMatch() async {
    isMatching.value = true;
    try {
      await createRoom();
    } catch (_) {
      isMatching.value = false;
    }
  }

  /// 取消匹配
  Future<void> cancelMatch() async {
    isMatching.value = false;
    await endSession();
  }
}
