import '../../core/network/api_client.dart';

/// 直播/广播电台相关 API Provider
/// 涵盖：广播电台分类、收藏、电台信息等
class LiveProvider {
  final _client = ApiClient();

  /// 广播电台 - 分类/地区信息
  Future<Map<String, dynamic>> getCategories() async {
    final r = await _client.get('/broadcast/category/region/get');
    return r.data;
  }

  /// 广播电台 - 全部电台
  Future<Map<String, dynamic>> getChannels({
    int? categoryId,
    int? regionId,
    int limit = 30,
    int? lastId,
    int? score,
  }) async {
    final r = await _client.get('/broadcast/channel/list', queryParameters: {
      if (categoryId != null) 'categoryId': categoryId,
      if (regionId != null) 'regionId': regionId,
      'limit': limit,
      if (lastId != null) 'lastId': lastId,
      if (score != null) 'score': score,
    });
    return r.data;
  }

  /// 广播电台 - 电台信息
  Future<Map<String, dynamic>> getChannelInfo({required int id}) async {
    final r = await _client.get('/broadcast/channel/currentinfo', queryParameters: {
      'id': id,
    });
    return r.data;
  }

  /// 广播电台 - 我的收藏
  Future<Map<String, dynamic>> getCollected({int limit = 30}) async {
    final r = await _client.get('/broadcast/channel/collect/list', queryParameters: {
      'limit': limit,
    });
    return r.data;
  }

  /// 广播电台 - 收藏/取消收藏
  /// t: 1 收藏, 2 取消收藏
  Future<Map<String, dynamic>> subscribe({
    required int t,
    required int id,
  }) async {
    final r = await _client.get('/broadcast/sub', queryParameters: {
      't': t,
      'id': id,
    });
    return r.data;
  }
}
