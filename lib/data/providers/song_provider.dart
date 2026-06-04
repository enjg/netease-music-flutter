import '../../core/network/api_client.dart';
import '../models/song_model.dart';

/// 歌曲相关API
class SongProvider {
  final _client = ApiClient();

  /// 歌曲详情
  Future<SongModel> getDetail(int id) async {
    final res = await _client.get('/song/detail', queryParameters: {'ids': id});
    return SongModel.fromJson(res.data['songs'][0]);
  }

  /// 歌词
  Future<String> getLyric(int id) async {
    final res = await _client.get('/lyric', queryParameters: {'id': id});
    return res.data['lrc']?['lyric'] ?? '';
  }

  /// 喜欢/取消喜欢
  Future<bool> like(int id, {bool like = true}) async {
    final res = await _client.post('/like', queryParameters: {'id': id, 'like': like});
    return res.data['code'] == 200;
  }

  /// 喜欢列表
  Future<List<int>> getLikeList(int uid) async {
    final res = await _client.get('/likelist', queryParameters: {'uid': uid});
    return (res.data['ids'] as List? ?? []).cast<int>();
  }

  /// 相似歌曲
  Future<List<SongModel>> getSimiSongs(int id) async {
    final res = await _client.get('/simi/song', queryParameters: {'id': id});
    return (res.data['songs'] as List? ?? [])
        .map((s) => SongModel.fromJson(s))
        .toList();
  }
}
