import '../../core/network/api_client.dart';
import '../models/banner_model.dart';
import '../models/song_model.dart';

/// 推荐相关API
class RecommendProvider {
  final _client = ApiClient();

  /// Banner轮播
  Future<List<BannerModel>> getBanners({int type = 0}) async {
    final res = await _client.get('/banner', queryParameters: {'type': type});
    return (res.data['banners'] as List? ?? [])
        .map((b) => BannerModel.fromJson(b))
        .where((b) => b.pic.isNotEmpty)
        .toList();
  }

  /// 推荐歌单
  Future<List<Map<String, dynamic>>> getPersonalized({int limit = 10}) async {
    final res = await _client.get('/personalized', queryParameters: {'limit': limit});
    return (res.data['result'] as List? ?? []).cast<Map<String, dynamic>>();
  }

  /// 新歌速递
  Future<List<SongModel>> getNewSongs({int limit = 12}) async {
    final res = await _client.get('/personalized/newsong', queryParameters: {'limit': limit});
    return (res.data['result'] as List? ?? [])
        .map((item) {
          final song = item['song'] ?? item;
          return SongModel.fromJson(song);
        })
        .toList();
  }

  /// 独家放送
  Future<List<Map<String, dynamic>>> getPrivateContent({int limit = 6}) async {
    final res = await _client.get('/personalized/privatecontent', queryParameters: {'limit': limit});
    return (res.data['result'] as List? ?? []).cast<Map<String, dynamic>>();
  }

  /// 推荐电台
  Future<List<Map<String, dynamic>>> getDjPrograms({int limit = 6}) async {
    final res = await _client.get('/personalized/djprogram', queryParameters: {'limit': limit});
    return (res.data['result'] as List? ?? []).cast<Map<String, dynamic>>();
  }

  /// 每日推荐歌曲
  Future<List<SongModel>> getDailySongs() async {
    final res = await _client.get('/recommend/songs');
    return (res.data['data']?['dailySongs'] as List? ?? [])
        .map((s) => SongModel.fromJson(s))
        .toList();
  }
}
