import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/models/song_model.dart';
import '../../data/models/playlist_model.dart';

class PlaylistController extends GetxController {
  final _client = ApiClient();

  // 广场
  final topPlaylists = <PlaylistModel>[].obs;
  final highQuality = <PlaylistModel>[].obs;
  final categories = <String, List<String>>{}.obs;
  final currentCat = '全部'.obs;
  final isLoadingSquare = true.obs;

  // 详情
  final detailId = RxnInt();
  final detail = Rx<Map<String, dynamic>>({});
  final tracks = <SongModel>[].obs;
  final subscribers = <Map<String, dynamic>>[].obs;
  final isLoadingDetail = true.obs;

  @override void onInit() {
    super.onInit();
    final id = Get.arguments?['id'] as int?;
    detailId.value = id;
    if (id != null) { loadDetail(id); }
    else { loadSquare(); }
  }

  // === 广场 ===
  Future<void> loadSquare() async {
    isLoadingSquare.value = true;
    try {
      await Future.wait([loadTopPlaylists(), loadHighQuality(), loadCategories()]);
    } finally { isLoadingSquare.value = false; }
  }

  Future<void> loadTopPlaylists() async {
    try {
      final r = await _client.get('/top/playlist', queryParameters: {'cat': currentCat.value, 'limit': 20});
      topPlaylists.assignAll((r.data['playlists'] ?? []).map((p) => PlaylistModel.fromJson(p)));
    } catch (_) {}
  }

  Future<void> loadHighQuality() async {
    try {
      final r = await _client.get('/top/playlist/highquality', queryParameters: {'cat': currentCat.value, 'limit': 10});
      highQuality.assignAll((r.data['playlists'] ?? []).map((p) => PlaylistModel.fromJson(p)));
    } catch (_) {}
  }

  Future<void> loadCategories() async {
    try {
      final r = await _client.get('/playlist/catlist');
      final sub = r.data['sub'] as List? ?? [];
      final cats = <String, List<String>>{};
      for (final s in sub) {
        final cat = s['category']?.toString() ?? '其他';
        cats.putIfAbsent(cat, () => []).add(s['name'] ?? '');
      }
      categories.value = cats;
    } catch (_) {}
  }

  void changeCat(String cat) {
    currentCat.value = cat;
    loadTopPlaylists();
    loadHighQuality();
  }

  // === 详情 ===
  Future<void> loadDetail(int id) async {
    isLoadingDetail.value = true;
    try {
      final r = await _client.get('/playlist/detail', queryParameters: {'id': id});
      detail.value = Map.from(r.data['playlist'] ?? {});
      await loadTracks(id);
      loadSubscribers(id);
    } finally { isLoadingDetail.value = false; }
  }

  Future<void> loadTracks(int id) async {
    try {
      final r = await _client.get('/playlist/track/all', queryParameters: {'id': id, 'limit': 50});
      tracks.assignAll((r.data['songs'] ?? []).map((s) => SongModel.fromJson(s)));
    } catch (_) {}
  }

  Future<void> loadSubscribers(int id) async {
    try {
      final r = await _client.get('/playlist/subscribers', queryParameters: {'id': id, 'limit': 10});
      subscribers.assignAll((r.data['subscribers'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  Future<bool> subscribe(int id, {bool sub = true}) async {
    try {
      final r = await _client.post('/playlist/subscribe', queryParameters: {'id': id, 't': sub ? 1 : 2});
      return r.data['code'] == 200;
    } catch (_) { return false; }
  }
}
