import '../../core/network/api_client.dart';

/// 歌手相关 API Provider
/// 涵盖：歌手详情、歌曲、专辑、MV、粉丝、收藏等
class ArtistProvider {
  final _client = ApiClient();

  /// 歌手单曲 (旧接口)
  Future<Map<String, dynamic>> getArtists({required int id}) async {
    final r = await _client.get('/artists', queryParameters: {'id': id});
    return r.data;
  }

  /// 歌手详情
  Future<Map<String, dynamic>> getArtistDetail({required int id}) async {
    final r = await _client.get('/artist/detail', queryParameters: {'id': id});
    return r.data;
  }

  /// 歌手动态信息
  Future<Map<String, dynamic>> getArtistDynamic({required int id}) async {
    final r = await _client.get('/artist/detail/dynamic', queryParameters: {'id': id});
    return r.data;
  }

  /// 歌手介绍
  Future<Map<String, dynamic>> getArtistDesc({required int id}) async {
    final r = await _client.get('/artist/desc', queryParameters: {'id': id});
    return r.data;
  }

  /// 歌手歌曲列表
  Future<Map<String, dynamic>> getArtistSongs({
    required int id,
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/artist/songs', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 歌手热门 50 首歌曲
  Future<Map<String, dynamic>> getArtistTopSongs({required int id}) async {
    final r = await _client.get('/artist/top/song', queryParameters: {'id': id});
    return r.data;
  }

  /// 歌手专辑列表
  Future<Map<String, dynamic>> getArtistAlbums({
    required int id,
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/artist/album', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 歌手相关 MV
  Future<Map<String, dynamic>> getArtistMvs({
    required int id,
    int limit = 20,
    int offset = 0,
  }) async {
    final r = await _client.get('/artist/mv', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 歌手相关视频
  Future<Map<String, dynamic>> getArtistVideos({
    required int id,
    int size = 20,
    String? cursor,
    int order = 1,
  }) async {
    final r = await _client.get('/artist/video', queryParameters: {
      'id': id,
      'size': size,
      if (cursor != null) 'cursor': cursor,
      'order': order,
    });
    return r.data;
  }

  /// 歌手粉丝数量
  Future<Map<String, dynamic>> getArtistFollowCount({required int id}) async {
    final r = await _client.get('/artist/follow/count', queryParameters: {'id': id});
    return r.data;
  }

  /// 歌手粉丝列表
  Future<Map<String, dynamic>> getArtistFans({
    required int id,
    int limit = 20,
    int offset = 0,
  }) async {
    final r = await _client.get('/artist/fans', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 收藏/取消收藏歌手
  /// t: 1 收藏, 2 取消收藏
  Future<Map<String, dynamic>> subscribeArtist({
    required int t,
    required int id,
  }) async {
    final r = await _client.get('/artist/sub', queryParameters: {'t': t, 'id': id});
    return r.data;
  }

  /// 关注歌手列表
  Future<Map<String, dynamic>> getArtistSublist({
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/artist/sublist', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 歌手分类
  /// type: -1全部 1男歌手 2女歌手 3乐队
  /// area: -1全部 7华语 96欧美 8日本 16韩国 0其他
  Future<Map<String, dynamic>> getArtistList({
    int type = -1,
    int area = -1,
    String? initial,
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/artist/list', queryParameters: {
      'type': type,
      'area': area,
      if (initial != null) 'initial': initial,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 相似歌手
  Future<Map<String, dynamic>> getSimilarArtists({required int id}) async {
    final r = await _client.get('/simi/artist', queryParameters: {'id': id});
    return r.data;
  }

  /// 歌手简要百科信息
  Future<Map<String, dynamic>> getArtistUgc({required int id}) async {
    final r = await _client.get('/ugc/artist/get', queryParameters: {'id': id});
    return r.data;
  }

  /// 搜索歌手
  Future<Map<String, dynamic>> searchArtist({
    required String keyword,
    int limit = 20,
  }) async {
    final r = await _client.get('/ugc/artist/search', queryParameters: {
      'keyword': keyword,
      'limit': limit,
    });
    return r.data;
  }

  /// 最新歌手 MV
  Future<Map<String, dynamic>> getArtistNewMv({
    int limit = 20,
    int? before,
  }) async {
    final r = await _client.get('/artist/new/mv', queryParameters: {
      'limit': limit,
      if (before != null) 'before': before,
    });
    return r.data;
  }

  /// 最新歌手歌曲
  Future<Map<String, dynamic>> getArtistNewSong({
    int limit = 20,
    int? before,
  }) async {
    final r = await _client.get('/artist/new/song', queryParameters: {
      'limit': limit,
      if (before != null) 'before': before,
    });
    return r.data;
  }
}
