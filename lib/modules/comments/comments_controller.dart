import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class CommentsController extends GetxController {
  final _client = ApiClient();
  final hotComments = <Map<String, dynamic>>[].obs;
  final newComments = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final currentTab = 'hot'.obs;
  final total = 0.obs;
  int _offset = 0;

  int get id => Get.arguments?['id'] ?? 0;
  int get type => Get.arguments?['type'] ?? 0; // 0=song,1=album,2=playlist,3=dj,4=mv

  static const _apiMap = {0: '/comment/music', 1: '/comment/album', 2: '/comment/playlist', 3: '/comment/dj', 4: '/comment/mv'};

  @override void onInit() { super.onInit(); loadComments(); }

  String get _api => _apiMap[type] ?? '/comment/music';

  Future<void> loadComments() async {
    isLoading.value = true;
    try {
      await Future.wait([loadHot(), loadNew()]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadHot() async {
    try {
      final r = await _client.get('/comment/hot', queryParameters: {'id': id, 'type': type, 'limit': 10});
      hotComments.assignAll((r.data['hotComments'] ?? []).cast<Map<String, dynamic>>());
    } catch(_) {}
  }

  Future<void> loadNew() async {
    try {
      final r = await _client.get(_api, queryParameters: {'id': id, 'limit': 20, 'offset': _offset, 'sortType': 3});
      newComments.assignAll((r.data['comments'] ?? []).cast<Map<String, dynamic>>());
      total.value = r.data['total'] ?? 0;
    } catch(_) {}
  }

  void switchTab(String tab) { currentTab.value = tab; }

  Future<bool> likeComment(int cid, bool like) async {
    try {
      final r = await _client.post('/comment/like', queryParameters: {'id': id, 'cid': cid, 't': like ? 1 : 0, 'type': type});
      return r.data['code'] == 200;
    } catch(_) { return false; }
  }

  Future<bool> sendComment(String content) async {
    try {
      final r = await _client.post('/comment', queryParameters: {'t': 1, 'type': type, 'id': id, 'content': content});
      if (r.data['code'] == 200) { loadComments(); return true; }
      return false;
    } catch(_) { return false; }
  }
}
