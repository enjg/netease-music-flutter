import '../../core/network/api_client.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';

/// 歌单相关API
class PlaylistProvider {
  final _client = ApiClient();

  /// 歌单详情
  Future<Map<String, dynamic>> getDetail(int id) async {
    final res = await _client.get('/playlist/detail', queryParameters: {'id': id});
    return res.data;
  }

  /// 歌单歌曲列表
  Future<List<SongModel>> getTracks(int id, {int limit = 50, int offset = 0}) async {
    final res = await _client.get('/playlist/track/all', queryParameters: {
      'id': id, 'limit': limit, 'offset': offset,
    });
    return (res.data['songs'] as List? ?? [])
        .map((s) => SongModel.fromJson(s))
        .toList();
  }

  /// 热门歌单
  Future<List<PlaylistModel>> getTopPlaylists({String cat = '全部', int limit = 20, int offset = 0}) async {
    final res = await _client.get('/top/playlist', queryParameters: {
      'cat': cat, 'limit': limit, 'offset': offset,
    });
    return (res.data['playlists'] as List? ?? [])
        .map((p) => PlaylistModel.fromJson(p))
        .toList();
  }

  /// 精品歌单
  Future<List<PlaylistModel>> getHighQuality({String cat = '全部', int limit = 20}) async {
    final res = await _client.get('/top/playlist/highquality', queryParameters: {
      'cat': cat, 'limit': limit,
    });
    return (res.data['playlists'] as List? ?? [])
        .map((p) => PlaylistModel.fromJson(p))
        .toList();
  }

  /// 歌单分类
  Future<Map<String, dynamic>> getCategories() async {
    final res = await _client.get('/playlist/catlist');
    return res.data;
  }

  /// 收藏/取消收藏歌单
  Future<bool> subscribe(int id, {bool subscribe = true}) async {
    final res = await _client.post('/playlist/subscribe', queryParameters: {
      'id': id, 't': subscribe ? 1 : 2,
    });
    return res.data['code'] == 200;
  }
}
