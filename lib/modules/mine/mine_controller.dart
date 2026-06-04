import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../shared/services/auth_service.dart';

class MineController extends GetxController {
  final _client = ApiClient();
  final authService = Get.find<AuthService>();

  final createdPlaylists = <Map<String, dynamic>>[].obs;
  final subscribedPlaylists = <Map<String, dynamic>>[].obs;
  final subCounts = <String, int>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() { super.onInit(); loadData(); }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final uid = authService.userId;
      if (uid == null) { isLoading.value = false; return; }
      await Future.wait([
        loadPlaylists(uid),
        loadSubCounts(),
      ]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadPlaylists(int uid) async {
    try {
      final r = await _client.get('/user/playlist', queryParameters: {'uid': uid, 'limit': 50});
      final all = (r.data['playlist'] ?? []).cast<Map<String, dynamic>>();
      createdPlaylists.assignAll(all.where((p) => p['creator']?['userId'] == uid));
      subscribedPlaylists.assignAll(all.where((p) => p['creator']?['userId'] != uid));
    } catch (_) {}
  }

  Future<void> loadSubCounts() async {
    try {
      final r = await _client.get('/user/subcount');
      subCounts.value = {
        'artists': r.data['artistCount'] ?? 0,
        'albums': r.data['albumCount'] ?? 0,
        'playlists': r.data['playlistCount'] ?? 0,
      };
    } catch (_) {}
  }
}
