import '../../core/network/api_client.dart';

/// 评论相关 API Provider
/// 涵盖：发送/删除评论、热门评论、点赞、各类资源评论等
class CommentProvider {
  final _client = ApiClient();

  /// 发送评论
  /// t: 1 发送, 0 删除
  /// type: 0 歌曲, 1 动态, 2 歌单, 3 专辑, 4 电台, 5 视频, 6 动态
  Future<Map<String, dynamic>> sendComment({
    required int t,
    required int type,
    required int id,
    String? content,
    int? commentId,
    String? threadId,
  }) async {
    final r = await _client.get('/comment', queryParameters: {
      't': t,
      'type': type,
      'id': id,
      if (content != null) 'content': content,
      if (commentId != null) 'commentId': commentId,
      if (threadId != null) 'threadId': threadId,
    });
    return r.data;
  }

  /// 热门评论
  /// type: 0 歌曲, 1 动态, 2 歌单, 3 专辑, 4 电台, 5 视频
  Future<Map<String, dynamic>> getHotComments({
    required int id,
    required int type,
    int limit = 20,
    int offset = 0,
  }) async {
    final r = await _client.get('/comment/hot', queryParameters: {
      'id': id,
      'type': type,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 最新评论
  /// sortType: 1 推荐, 2 最热, 3 时间
  Future<Map<String, dynamic>> getNewComments({
    required int id,
    required int type,
    int sortType = 1,
    int limit = 20,
    int offset = 0,
  }) async {
    final r = await _client.get('/comment/new', queryParameters: {
      'id': id,
      'type': type,
      'sortType': sortType,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 点赞/取消点赞评论
  /// t: 1 点赞, 0 取消
  /// type: 0 歌曲, 1 动态, 2 歌单, 3 专辑, 4 电台, 5 视频
  Future<Map<String, dynamic>> likeComment({
    required int t,
    required int type,
    required int id,
    required int cid,
    String? threadId,
  }) async {
    final r = await _client.get('/comment/like', queryParameters: {
      't': t,
      'type': type,
      'id': id,
      'cid': cid,
      if (threadId != null) 'threadId': threadId,
    });
    return r.data;
  }

  /// 歌曲评论
  Future<Map<String, dynamic>> getMusicComments({
    required int id,
    int limit = 20,
    int offset = 0,
    int? before,
  }) async {
    final r = await _client.get('/comment/music', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// 歌单评论
  Future<Map<String, dynamic>> getPlaylistComments({
    required int id,
    int limit = 20,
    int offset = 0,
    int? before,
  }) async {
    final r = await _client.get('/comment/playlist', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// 专辑评论
  Future<Map<String, dynamic>> getAlbumComments({
    required int id,
    int limit = 20,
    int offset = 0,
    int? before,
  }) async {
    final r = await _client.get('/comment/album', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// MV 评论
  Future<Map<String, dynamic>> getMvComments({
    required int id,
    int limit = 20,
    int offset = 0,
    int? before,
  }) async {
    final r = await _client.get('/comment/mv', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// 电台评论
  Future<Map<String, dynamic>> getDjComments({
    required int id,
    int limit = 20,
    int offset = 0,
    int? before,
  }) async {
    final r = await _client.get('/comment/dj', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// 视频评论
  Future<Map<String, dynamic>> getVideoComments({
    required int id,
    int limit = 20,
    int offset = 0,
    int? before,
  }) async {
    final r = await _client.get('/comment/video', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// 动态评论
  Future<Map<String, dynamic>> getEventComments({
    required String threadId,
    int limit = 20,
    int offset = 0,
    int? before,
  }) async {
    final r = await _client.get('/comment/event', queryParameters: {
      'threadId': threadId,
      'limit': limit,
      'offset': offset,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// 楼层评论
  Future<Map<String, dynamic>> getCommentFloor({
    required int type,
    required int parentCommentId,
    required int id,
    int? time,
    int limit = 20,
  }) async {
    final r = await _client.get('/comment/floor', queryParameters: {
      'type': type,
      'parentCommentId': parentCommentId,
      'id': id,
      if (time != null) 'time': time,
      'limit': limit,
    });
    return r.data;
  }

  /// 评论抱一抱列表
  Future<Map<String, dynamic>> getHugList({
    required int type,
    required int sid,
    required int uid,
    required int cid,
    String? cursor,
    int page = 1,
    int pageSize = 20,
  }) async {
    final r = await _client.get('/comment/hug/list', queryParameters: {
      'type': type,
      'sid': sid,
      'uid': uid,
      'cid': cid,
      if (cursor != null) 'cursor': cursor,
      'page': page,
      'pageSize': pageSize,
    });
    return r.data;
  }

  /// 评论
  Future<Map<String, dynamic>> hugComment({
    required int type,
    required int sid,
    required int uid,
    required int cid,
  }) async {
    final r = await _client.get('/hug/comment', queryParameters: {
      'type': type,
      'sid': sid,
      'uid': uid,
      'cid': cid,
    });
    return r.data;
  }

  /// 收到的评论
  Future<Map<String, dynamic>> getMyComments({
    int? before,
    int limit = 20,
    int? uid,
  }) async {
    final r = await _client.get('/msg/comments', queryParameters: {
      if (before != null) 'before': before,
      'limit': limit,
      if (uid != null) 'uid': uid,
    });
    return r.data;
  }

  /// 云村星评馆 - 简要评论列表
  Future<Map<String, dynamic>> getStarpickComments() async {
    final r = await _client.get('/starpick/comments/summary');
    return r.data;
  }

  /// 用户评论历史
  Future<Map<String, dynamic>> getUserCommentHistory({
    required int uid,
    int limit = 20,
    int? time,
  }) async {
    final r = await _client.get('/user/comment/history', queryParameters: {
      'uid': uid,
      'limit': limit,
      if (time != null) 'time': time,
    });
    return r.data;
  }
}
