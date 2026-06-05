import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/models/song_model.dart';

class RecentPlayController extends GetxController {
  final _client = ApiClient();
  final songs = <SongModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() { super.onInit(); loadRecent(); }

  Future<void> loadRecent() async {
    isLoading.value = true;
    try {
      final r = await _client.get('/record/recent/song', queryParameters: {'limit': 100});
      final list = (r.data['data']?.cast<Map<String, dynamic>>() ?? []);
      songs.assignAll(list.map((item) {
        final s = item['data'] ?? item;
        return SongModel.fromJson(s is Map<String, dynamic> ? s : {});
      }).where((s) => s.id > 0).toList());
    } catch (_) {}
    isLoading.value = false;
  }
}
