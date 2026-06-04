import '../../core/network/api_client.dart';

/// 专辑相关 API Provider
/// 涵盖：专辑内容、数字专辑、新碟上架、收藏、评论等
class AlbumProvider {
  final _client = ApiClient();

  /// 专辑内容
  Future<Map<String, dynamic>> getAlbum({required int id}) async {
    final r = await _client.get('/album', queryParameters: {'id': id});
    return r.data;
  }

  /// 数字专辑详情
  Future<Map<String, dynamic>> getAlbumDetail({required int id}) async {
    final r = await _client.get('/album/detail', queryParameters: {'id': id});
    return r.data;
  }

  /// 专辑动态信息
  Future<Map<String, dynamic>> getAlbumDynamic({required int id}) async {
    final r = await _client.get('/album/detail/dynamic', queryParameters: {'id': id});
    return r.data;
  }

  /// 获取专辑歌曲的音质
  Future<Map<String, dynamic>> getAlbumPrivilege({required int id}) async {
    final r = await _client.get('/album/privilege', queryParameters: {'id': id});
    return r.data;
  }

  /// 数字专辑-新碟上架
  Future<Map<String, dynamic>> getAlbumList({
    int limit = 50,
    int offset = 0,
    int? area,
    int? type,
  }) async {
    final r = await _client.get('/album/list', queryParameters: {
      'limit': limit,
      'offset': offset,
      if (area != null) 'area': area,
      if (type != null) 'type': type,
    });
    return r.data;
  }

  /// 数字专辑-语种风格馆
  Future<Map<String, dynamic>> getAlbumListStyle({
    int limit = 50,
    int offset = 0,
    int? area,
  }) async {
    final r = await _client.get('/album/list/style', queryParameters: {
      'limit': limit,
      'offset': offset,
      if (area != null) 'area': area,
    });
    return r.data;
  }

  /// 全部新碟
  Future<Map<String, dynamic>> getAlbumNew({
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/album/new', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 最新专辑
  Future<Map<String, dynamic>> getAlbumNewest() async {
    final r = await _client.get('/album/newest');
    return r.data;
  }

  /// 收藏/取消收藏专辑
  /// t: 1 收藏, 2 取消收藏
  Future<Map<String, dynamic>> subscribeAlbum({
    required int t,
    required int id,
  }) async {
    final r = await _client.get('/album/sub', queryParameters: {'t': t, 'id': id});
    return r.data;
  }

  /// 已收藏专辑列表
  Future<Map<String, dynamic>> getAlbumSublist({
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/album/sublist', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 数字专辑&数字单曲-榜单
  Future<Map<String, dynamic>> getAlbumSaleBoard({
    int? albumType,
    int? type,
    int? year,
  }) async {
    final r = await _client.get('/album/songsaleboard', queryParameters: {
      if (albumType != null) 'albumType': albumType,
      if (type != null) 'type': type,
      if (year != null) 'year': year,
    });
    return r.data;
  }

  /// 数字专辑详情
  Future<Map<String, dynamic>> getDigitalAlbumDetail({required int id}) async {
    final r = await _client.get('/digitalAlbum/detail', queryParameters: {'id': id});
    return r.data;
  }

  /// 数字专辑销量
  Future<Map<String, dynamic>> getDigitalAlbumSales({required String ids}) async {
    final r = await _client.get('/digitalAlbum/sales', queryParameters: {'ids': ids});
    return r.data;
  }

  /// 我的数字专辑
  Future<Map<String, dynamic>> getDigitalAlbumPurchased({
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/digitalAlbum/purchased', queryParameters: {
      'limit': limit,
      'offset': offset,
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

  /// 最近播放-专辑
  Future<Map<String, dynamic>> getRecentAlbum({int limit = 50}) async {
    final r = await _client.get('/record/recent/album', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 专辑简要百科信息
  Future<Map<String, dynamic>> getAlbumUgc({required int id}) async {
    final r = await _client.get('/ugc/album/get', queryParameters: {'id': id});
    return r.data;
  }
}
