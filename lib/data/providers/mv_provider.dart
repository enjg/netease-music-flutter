import '../../core/network/api_client.dart';

/// MV/视频相关 API Provider
/// 涵盖：MV详情、视频详情、推荐、排行榜、收藏等
class MvProvider {
  final _client = ApiClient();

  /// 全部 MV
  /// area: 内地/港台/欧美/日本/韩国
  /// type: 全部/官方版/原声/现场版/网易出品
  /// order: 上升最快/最新/最热
  Future<Map<String, dynamic>> getAllMv({
    String? area,
    String? type,
    String? order,
    int offset = 0,
    int limit = 30,
  }) async {
    final r = await _client.get('/mv/all', queryParameters: {
      if (area != null) 'area': area,
      if (type != null) 'type': type,
      if (order != null) 'order': order,
      'offset': offset,
      'limit': limit,
    });
    return r.data;
  }

  /// 最新 MV
  /// area: 内地/港台/欧美/日本/韩国
  Future<Map<String, dynamic>> getNewMv({
    String? area,
    int offset = 0,
    int limit = 30,
  }) async {
    final r = await _client.get('/mv/first', queryParameters: {
      if (area != null) 'area': area,
      'offset': offset,
      'limit': limit,
    });
    return r.data;
  }

  /// 网易出品 MV
  Future<Map<String, dynamic>> getExclusiveMv({
    int offset = 0,
    int limit = 30,
  }) async {
    final r = await _client.get('/mv/exclusive/rcmd', queryParameters: {
      'offset': offset,
      'limit': limit,
    });
    return r.data;
  }

  /// 推荐 MV
  Future<Map<String, dynamic>> getPersonalizedMv() async {
    final r = await _client.get('/personalized/mv');
    return r.data;
  }

  /// MV 排行榜
  Future<Map<String, dynamic>> getTopMv({
    String area = '内地',
    int offset = 0,
    int limit = 30,
  }) async {
    final r = await _client.get('/top/mv', queryParameters: {
      'area': area,
      'offset': offset,
      'limit': limit,
    });
    return r.data;
  }

  /// MV 详情
  Future<Map<String, dynamic>> getMvDetail({required int mvid}) async {
    final r = await _client.get('/mv/detail', queryParameters: {'mvid': mvid});
    return r.data;
  }

  /// MV 点赞转发评论数数据
  Future<Map<String, dynamic>> getMvDetailInfo({required int mvid}) async {
    final r = await _client.get('/mv/detail/info', queryParameters: {'mvid': mvid});
    return r.data;
  }

  /// MV 链接
  Future<Map<String, dynamic>> getMvUrl({
    required int id,
    int r = 1080,
  }) async {
    final r2 = await _client.get('/mv/url', queryParameters: {'id': id, 'r': r});
    return r2.data;
  }

  /// 相似 MV
  Future<Map<String, dynamic>> getSimilarMv({required int mvid}) async {
    final r = await _client.get('/simi/mv', queryParameters: {'mvid': mvid});
    return r.data;
  }

  /// 收藏/取消收藏 MV
  /// t: 1 收藏, 2 取消收藏
  Future<Map<String, dynamic>> subscribeMv({
    required int t,
    required int mvid,
  }) async {
    final r = await _client.get('/mv/sub', queryParameters: {'t': t, 'mvid': mvid});
    return r.data;
  }

  /// 已收藏 MV 列表
  Future<Map<String, dynamic>> getMvSublist({
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/mv/sublist', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// MV 简要百科信息
  Future<Map<String, dynamic>> getMvUgc({required int id}) async {
    final r = await _client.get('/ugc/mv/get', queryParameters: {'id': id});
    return r.data;
  }

  /// 视频详情
  Future<Map<String, dynamic>> getVideoDetail({required String id}) async {
    final r = await _client.get('/video/detail', queryParameters: {'id': id});
    return r.data;
  }

  /// 视频点赞转发评论数数据
  Future<Map<String, dynamic>> getVideoDetailInfo({required String vid}) async {
    final r = await _client.get('/video/detail/info', queryParameters: {'vid': vid});
    return r.data;
  }

  /// 视频链接
  Future<Map<String, dynamic>> getVideoUrl({
    required String id,
    int res = 1080,
  }) async {
    final r = await _client.get('/video/url', queryParameters: {'id': id, 'res': res});
    return r.data;
  }

  /// 相关视频
  Future<Map<String, dynamic>> getRelatedVideos({required String id}) async {
    final r = await _client.get('/related/allvideo', queryParameters: {'id': id});
    return r.data;
  }

  /// 收藏/取消收藏视频
  /// t: 1 收藏, 2 取消收藏
  Future<Map<String, dynamic>> subscribeVideo({
    required int t,
    required String id,
  }) async {
    final r = await _client.get('/video/sub', queryParameters: {'t': t, 'id': id});
    return r.data;
  }

  /// 视频标签列表
  Future<Map<String, dynamic>> getVideoGroupList() async {
    final r = await _client.get('/video/group/list');
    return r.data;
  }

  /// 视频分类列表
  Future<Map<String, dynamic>> getVideoCategoryList({
    int offset = 0,
    int limit = 30,
  }) async {
    final r = await _client.get('/video/category/list', queryParameters: {
      'offset': offset,
      'limit': limit,
    });
    return r.data;
  }

  /// 视频标签/分类下的视频
  Future<Map<String, dynamic>> getVideoByGroup({
    required String id,
    String? offset,
  }) async {
    final r = await _client.get('/video/group', queryParameters: {
      'id': id,
      if (offset != null) 'offset': offset,
    });
    return r.data;
  }

  /// 推荐视频
  Future<Map<String, dynamic>> getRecommendVideos({String? offset}) async {
    final r = await _client.get('/video/timeline/recommend', queryParameters: {
      if (offset != null) 'offset': offset,
    });
    return r.data;
  }

  /// 全部视频列表
  Future<Map<String, dynamic>> getAllVideos({String? offset}) async {
    final r = await _client.get('/video/timeline/all', queryParameters: {
      if (offset != null) 'offset': offset,
    });
    return r.data;
  }

  /// 最近播放视频
  Future<Map<String, dynamic>> getRecentVideos({int limit = 30}) async {
    final r = await _client.get('/record/recent/video', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 最近播放歌单视频
  Future<Map<String, dynamic>> getRecentPlaylistVideos() async {
    final r = await _client.get('/playlist/video/recent');
    return r.data;
  }

  /// 点赞 MV
  /// t: 0 取消点赞, 1 点赞
  Future<Map<String, dynamic>> likeMv({
    required int t,
    required int id,
  }) async {
    final r = await _client.get('/resource/like', queryParameters: {
      'type': 1,
      't': t,
      'id': id,
    });
    return r.data;
  }

  /// 将 mlog id 转为 video id
  Future<Map<String, dynamic>> mlogToVideo({required String id}) async {
    final r = await _client.get('/mlog/to/video', queryParameters: {'id': id});
    return r.data;
  }
}
