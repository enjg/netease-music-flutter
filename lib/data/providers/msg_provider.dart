import '../../core/network/api_client.dart';

/// 消息相关 API Provider
/// 涵盖：私信、评论、@我、通知等
class MsgProvider {
  final _client = ApiClient();

  /// 私信列表
  Future<Map<String, dynamic>> getPrivateMsg({
    int offset = 0,
    int limit = 30,
  }) async {
    final r = await _client.get('/msg/private', queryParameters: {
      'offset': offset,
      'limit': limit,
    });
    return r.data;
  }

  /// 私信内容/聊天记录
  Future<Map<String, dynamic>> getPrivateHistory({
    required int uid,
    int limit = 30,
    int? before,
  }) async {
    final r = await _client.get('/msg/private/history', queryParameters: {
      'uid': uid,
      'limit': limit,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// 最近联系人
  Future<Map<String, dynamic>> getRecentContact() async {
    final r = await _client.get('/msg/recentcontact');
    return r.data;
  }

  /// 收到的评论
  Future<Map<String, dynamic>> getComments({
    int? before,
    int limit = 30,
    int? uid,
  }) async {
    final r = await _client.get('/msg/comments', queryParameters: {
      if (before != null) 'before': before,
      'limit': limit,
      if (uid != null) 'uid': uid,
    });
    return r.data;
  }

  /// @我
  Future<Map<String, dynamic>> getForwards({
    int offset = 0,
    int limit = 30,
  }) async {
    final r = await _client.get('/msg/forwards', queryParameters: {
      'offset': offset,
      'limit': limit,
    });
    return r.data;
  }

  /// 通知
  Future<Map<String, dynamic>> getNotices({
    int limit = 30,
    int? lasttime,
  }) async {
    final r = await _client.get('/msg/notices', queryParameters: {
      'limit': limit,
      if (lasttime != null) 'lasttime': lasttime,
    });
    return r.data;
  }
}
