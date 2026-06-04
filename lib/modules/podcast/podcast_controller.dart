import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class PodcastController extends GetxController {
  final _client = ApiClient();
  final banners = <Map<String, dynamic>>[].obs;
  final categories = <Map<String, dynamic>>[].obs;
  final recommendDj = <Map<String, dynamic>>[].obs;
  final hotDj = <Map<String, dynamic>>[].obs;
  final rankDj = <Map<String, dynamic>>[].obs;
  final programRank = <Map<String, dynamic>>[].obs;
  final personalRec = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() { super.onInit(); loadData(); }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadBanners(), loadCategories(), loadRecommend(),
        loadHot(), loadRank(), loadProgramRank(), loadPersonalRec(),
      ]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadBanners() async {
    try { final r = await _client.get('/dj/banner'); banners.assignAll((r.data['data'] ?? []).cast<Map<String, dynamic>>()); } catch(_){}
  }
  Future<void> loadCategories() async {
    try { final r = await _client.get('/dj/catelist'); categories.assignAll((r.data['categories'] ?? []).cast<Map<String, dynamic>>()); } catch(_){}
  }
  Future<void> loadRecommend() async {
    try { final r = await _client.get('/dj/recommend', queryParameters: {'limit': 10}); recommendDj.assignAll((r.data['djRadios'] ?? []).cast<Map<String, dynamic>>()); } catch(_){}
  }
  Future<void> loadHot() async {
    try { final r = await _client.get('/dj/hot', queryParameters: {'limit': 10}); hotDj.assignAll((r.data['djRadios'] ?? r.data['toplist'] ?? []).cast<Map<String, dynamic>>()); } catch(_){}
  }
  Future<void> loadRank() async {
    try { final r = await _client.get('/dj/rank', queryParameters: {'limit': 10}); rankDj.assignAll((r.data['data']?['list'] ?? r.data['toplist'] ?? []).cast<Map<String, dynamic>>()); } catch(_){}
  }
  Future<void> loadProgramRank() async {
    try { final r = await _client.get('/dj/program/toplist', queryParameters: {'limit': 10}); programRank.assignAll((r.data['toplist'] ?? []).cast<Map<String, dynamic>>()); } catch(_){}
  }
  Future<void> loadPersonalRec() async {
    try { final r = await _client.get('/dj/personalize/recom', queryParameters: {'limit': 6}); personalRec.assignAll((r.data['data'] ?? []).cast<Map<String, dynamic>>()); } catch(_){}
  }
}
