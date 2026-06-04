import '../../core/network/api_client.dart';

/// 搜索相关API
class SearchProvider {
  final _client = ApiClient();

  /// 搜索
  Future<Map<String, dynamic>> search(String keywords, {int type = 1, int limit = 30, int offset = 0}) async {
    final res = await _client.get('/search', queryParameters: {
      'keywords': keywords, 'type': type, 'limit': limit, 'offset': offset,
    });
    return res.data;
  }

  /// 云搜索(更多结果)
  Future<Map<String, dynamic>> cloudSearch(String keywords, {int type = 1, int limit = 30, int offset = 0}) async {
    final res = await _client.get('/cloudsearch', queryParameters: {
      'keywords': keywords, 'type': type, 'limit': limit, 'offset': offset,
    });
    return res.data;
  }

  /// 默认搜索词
  Future<Map<String, dynamic>> getDefault() async {
    final res = await _client.get('/search/default');
    return res.data['data'] ?? {};
  }

  /// 热搜列表
  Future<List<Map<String, dynamic>>> getHotDetail() async {
    final res = await _client.get('/search/hot/detail');
    return (res.data['data'] as List? ?? []).cast<Map<String, dynamic>>();
  }

  /// 搜索建议
  Future<Map<String, dynamic>> getSuggest(String keywords) async {
    final res = await _client.get('/search/suggest', queryParameters: {'keywords': keywords});
    return res.data['result'] ?? {};
  }
}
