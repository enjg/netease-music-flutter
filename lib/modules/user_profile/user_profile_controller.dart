import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../shared/services/auth_service.dart';

class UserProfileController extends GetxController {
  final _client = ApiClient();
  final authService = Get.find<AuthService>();
  final profile = Rx<Map<String, dynamic>>({});
  final playlists = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  int? get uid => Get.arguments?['uid'];

  @override
  void onInit() { super.onInit(); if (uid != null) loadData(); }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([loadProfile(), loadPlaylists()]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadProfile() async {
    try {
      final r = await _client.get('/user/detail', queryParameters: {'uid': uid});
      profile.value = Map.from(r.data['profile'] ?? r.data);
    } catch (_) {}
  }

  Future<void> loadPlaylists() async {
    try {
      final r = await _client.get('/user/playlist', queryParameters: {'uid': uid, 'limit': 30});
      playlists.assignAll((r.data['playlist'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  Future<void> toggleFollow(bool follow) async {
    try {
      await _client.get('/follow', queryParameters: {'t': follow ? 1 : 0, 'id': uid});
      await loadProfile();
    } catch (_) {}
  }
}
