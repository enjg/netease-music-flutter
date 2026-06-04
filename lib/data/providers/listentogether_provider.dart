import '../../core/network/api_client.dart';

/// 一起听相关 API Provider
/// 涵盖：创建房间、加入房间、心跳、播放控制、列表同步等
class ListenTogetherProvider {
  final _client = ApiClient();

  /// 一起听状态
  Future<Map<String, dynamic>> getStatus() async {
    final r = await _client.get('/listentogether/status');
    return r.data;
  }

  /// 创建一起听房间
  Future<Map<String, dynamic>> createRoom() async {
    final r = await _client.get('/listentogether/room/create');
    return r.data;
  }

  /// 检查房间情况
  Future<Map<String, dynamic>> checkRoom({required String roomId}) async {
    final r = await _client.get('/listentogether/room/check', queryParameters: {
      'roomId': roomId,
    });
    return r.data;
  }

  /// 接受邀请加入房间
  Future<Map<String, dynamic>> accept({
    required String roomId,
    required int inviterId,
  }) async {
    final r = await _client.get('/listentogether/accept', queryParameters: {
      'roomId': roomId,
      'inviterId': inviterId,
    });
    return r.data;
  }

  /// 结束房间
  Future<Map<String, dynamic>> endRoom({required String roomId}) async {
    final r = await _client.get('/listentogether/end', queryParameters: {
      'roomId': roomId,
    });
    return r.data;
  }

  /// 发送心跳
  Future<Map<String, dynamic>> heartbeat({
    required String roomId,
    required int songId,
    int playStatus = 1,
    int progress = 0,
  }) async {
    final r = await _client.get('/listentogether/heatbeat', queryParameters: {
      'roomId': roomId,
      'songId': songId,
      'playStatus': playStatus,
      'progress': progress,
    });
    return r.data;
  }

  /// 发送播放状态命令
  /// commandType: 播放/暂停/切歌等
  Future<Map<String, dynamic>> sendPlayCommand({
    required String roomId,
    required int commandType,
    int progress = 0,
    int playStatus = 1,
    int? formerSongId,
    int? targetSongId,
    int? clientSeq,
  }) async {
    final r = await _client.get('/listentogether/play/command', queryParameters: {
      'roomId': roomId,
      'commandType': commandType,
      'progress': progress,
      'playStatus': playStatus,
      if (formerSongId != null) 'formerSongId': formerSongId,
      if (targetSongId != null) 'targetSongId': targetSongId,
      if (clientSeq != null) 'clientSeq': clientSeq,
    });
    return r.data;
  }

  /// 更新播放列表
  Future<Map<String, dynamic>> syncList({
    required String roomId,
    required int commandType,
    required int userId,
    required int version,
    List<int>? randomList,
    List<int>? displayList,
  }) async {
    final r = await _client.get('/listentogether/sync/list/command', queryParameters: {
      'roomId': roomId,
      'commandType': commandType,
      'userId': userId,
      'version': version,
      if (randomList != null) 'randomList': randomList.join(','),
      if (displayList != null) 'displayList': displayList.join(','),
    });
    return r.data;
  }

  /// 获取当前播放列表
  Future<Map<String, dynamic>> getPlaylist({required String roomId}) async {
    final r = await _client.get('/listentogether/sync/playlist/get', queryParameters: {
      'roomId': roomId,
    });
    return r.data;
  }
}
