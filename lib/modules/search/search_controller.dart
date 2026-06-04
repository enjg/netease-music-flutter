import 'package:get/get.dart';
import '../../data/providers/search_provider.dart';
import '../../core/storage/local_storage.dart';

class SearchPageController extends GetxController {
  final _provider = SearchProvider();
  final _storage = LocalStorage();

  final keyword = ''.obs;
  final defaultKeyword = '搜索'.obs;
  final hotList = <Map<String, dynamic>>[].obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  final history = <String>[].obs;
  final isLoading = false.obs;
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    history.assignAll(_storage.searchHistory);
    loadDefault();
    loadHot();
  }

  Future<void> loadDefault() async {
    try {
      final data = await _provider.getDefault();
      defaultKeyword.value = data['showKeyword'] ?? '搜索';
    } catch (_) {}
  }

  Future<void> loadHot() async {
    try { hotList.assignAll(await _provider.getHotDetail()); } catch (_) {}
  }

  Future<void> search(String kw) async {
    if (kw.isEmpty) return;
    keyword.value = kw;
    isSearching.value = true;
    isLoading.value = true;
    await _storage.addSearchHistory(kw);
    history.assignAll(_storage.searchHistory);
    try {
      final data = await _provider.search(kw, type: 1, limit: 30);
      searchResults.assignAll((data['result']?['songs'] as List? ?? []).cast<Map<String, dynamic>>());
    } finally {
      isLoading.value = false;
    }
  }

  void clearHistory() {
    _storage.clearSearchHistory();
    history.clear();
  }
}
