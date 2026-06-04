import '../../core/network/api_client.dart';

/// 排行榜相关 API Provider
/// 涵盖：榜单列表、榜单详情、新歌速递、新碟上架、热门歌手、MV排行等
class ChartsProvider {
  final _client = ApiClient();

  /// 所有榜单介绍
  Future<Map<String, dynamic>> getToplist() async {
    final r = await _client.get('/toplist');
    return r.data;
  }

  /// 所有榜单内容摘要
  Future<Map<String, dynamic>> getToplistDetail() async {
    final r = await _client.get('/toplist/detail');
    return r.data;
  }

  /// 所有榜单内容摘要 v2
  Future<Map<String, dynamic>> getToplistDetailV2() async {
    final r = await _client.get('/toplist/detail/v2');
    return r.data;
  }

  /// 排行榜详情 (根据 idx)
  Future<Map<String, dynamic>> getTopList({
    required int idx,
    String? id,
  }) async {
    final r = await _client.get('/top/list', queryParameters: {
      'idx': idx,
      if (id != null) 'id': id,
    });
    return r.data;
  }

  /// 歌手榜
  Future<Map<String, dynamic>> getToplistArtist({int type = 1}) async {
    final r = await _client.get('/toplist/artist', queryParameters: {'type': type});
    return r.data;
  }

  /// 新歌速递
  /// type: 0 全部, 7 华语, 96 欧美, 8 日本, 16 韩国
  Future<Map<String, dynamic>> getTopSongs({int type = 0}) async {
    final r = await _client.get('/top/song', queryParameters: {'type': type});
    return r.data;
  }

  /// 新碟上架
  Future<Map<String, dynamic>> getTopAlbum({
    int? area,
    int? type,
    int? year,
    int? month,
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/top/album', queryParameters: {
      if (area != null) 'area': area,
      if (type != null) 'type': type,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 热门歌手
  Future<Map<String, dynamic>> getTopArtists({
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/top/artists', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// MV 排行榜
  /// area: 内地/港台/欧美/日本/韩国
  Future<Map<String, dynamic>> getTopMv({
    String area = '内地',
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/top/mv', queryParameters: {
      'area': area,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 获取指定维度音乐排行榜详情
  Future<Map<String, dynamic>> getChartDetail({
    required String chartCode,
    String? targetId,
    String? targetType,
  }) async {
    final r = await _client.get('/chart/detail', queryParameters: {
      'chartCode': chartCode,
      if (targetId != null) 'targetId': targetId,
      if (targetType != null) 'targetType': targetType,
    });
    return r.data;
  }

  /// 获取指定维度音乐排行榜列表
  Future<Map<String, dynamic>> getChartSongDetail({
    required String chartCode,
    String? targetId,
    String? targetType,
  }) async {
    final r = await _client.get('/chart/song/detail', queryParameters: {
      'chartCode': chartCode,
      if (targetId != null) 'targetId': targetId,
      if (targetType != null) 'targetType': targetType,
    });
    return r.data;
  }

  /// 乐谱列表
  Future<Map<String, dynamic>> getSheetList({
    int? id,
    String? ab,
    int limit = 10,
  }) async {
    final r = await _client.get('/sheet/list', queryParameters: {
      if (id != null) 'id': id,
      if (ab != null) 'ab': ab,
      'limit': limit,
    });
    return r.data;
  }

  /// 乐谱预览
  Future<Map<String, dynamic>> getSheetPreview({required int id}) async {
    final r = await _client.get('/sheet/preview', queryParameters: {'id': id});
    return r.data;
  }
}
