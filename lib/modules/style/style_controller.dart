import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/models/song_model.dart';

class StyleController extends GetxController {
  final _client = ApiClient();
  final styles = <Map<String, dynamic>>[].obs;
  final songs = <SongModel>[].obs;
  final albums = <Map<String, dynamic>>[].obs;
  final artists = <Map<String, dynamic>>[].obs;
  final playlists = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final selectedTagId = 0.obs;

  @override void onInit() { super.onInit(); loadStyles(); }

  Future<void> loadStyles() async {
    isLoading.value = true;
    try { final r = await _client.get('/style/list'); styles.assignAll((r.data['data'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
    finally { isLoading.value = false; }
  }

  Future<void> loadDetail(int tagId) async {
    selectedTagId.value = tagId;
    isLoading.value = true;
    try {
      await Future.wait([loadSongs(tagId), loadAlbums(tagId), loadArtists(tagId), loadPlaylists(tagId)]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadSongs(int tagId) async {
    try { final r = await _client.get('/style/song', queryParameters: {'tagId': tagId, 'limit': 30}); songs.assignAll((r.data['data']?['songs'] ?? []).map((s) => SongModel.fromJson(s))); } catch(_) {}
  }
  Future<void> loadAlbums(int tagId) async {
    try { final r = await _client.get('/style/album', queryParameters: {'tagId': tagId, 'limit': 18}); albums.assignAll((r.data['data']?['albums'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
  }
  Future<void> loadArtists(int tagId) async {
    try { final r = await _client.get('/style/artist', queryParameters: {'tagId': tagId, 'limit': 20}); artists.assignAll((r.data['data']?['artists'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
  }
  Future<void> loadPlaylists(int tagId) async {
    try { final r = await _client.get('/style/playlist', queryParameters: {'tagId': tagId, 'limit': 18}); playlists.assignAll((r.data['data']?['playlists'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
  }
}
