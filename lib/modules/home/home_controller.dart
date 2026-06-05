import 'package:get/get.dart';
import '../../data/providers/recommend_provider.dart';
import '../../data/providers/search_provider.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/song_model.dart';

class HomeController extends GetxController {
  final _provider = RecommendProvider();
  final _searchProvider = SearchProvider();

  final banners = <BannerModel>[].obs;
  final playlists = <Map<String, dynamic>>[].obs;
  final newSongs = <SongModel>[].obs;
  final privateContent = <Map<String, dynamic>>[].obs;
  final djPrograms = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final defaultSearch = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadBanners(),
        loadPlaylists(),
        loadNewSongs(),
        loadPrivateContent(),
        loadDjPrograms(),
        loadDefaultSearch(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBanners() async {
    try { banners.assignAll(await _provider.getBanners()); } catch (_) {}
  }

  Future<void> loadPlaylists() async {
    try { playlists.assignAll(await _provider.getPersonalized()); } catch (_) {}
  }

  Future<void> loadNewSongs() async {
    try { newSongs.assignAll(await _provider.getNewSongs()); } catch (_) {}
  }

  Future<void> loadPrivateContent() async {
    try { privateContent.assignAll(await _provider.getPrivateContent()); } catch (_) {}
  }

  Future<void> loadDjPrograms() async {
    try { djPrograms.assignAll(await _provider.getDjPrograms()); } catch (_) {}
  }

  Future<void> loadDefaultSearch() async {
    try {
      final data = await _searchProvider.getDefault();
      defaultSearch.value = data['showKeyword'] ?? data['realkeyword'] ?? '';
    } catch (_) {}
  }
}
