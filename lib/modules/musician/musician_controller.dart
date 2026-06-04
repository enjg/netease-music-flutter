import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class MusicianController extends GetxController {
  final _client = ApiClient();
  final overview = Rx<Map<String, dynamic>>({});
  final todayData = Rx<Map<String, dynamic>>({});
  final cloudbean = 0.obs;
  final tasks = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override void onInit() { super.onInit(); loadData(); }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([loadOverview(), loadToday(), loadBean(), loadTasks()]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadOverview() async {
    try { final r = await _client.get('/musician/data/overview'); overview.value = Map.from(r.data['data'] ?? {}); } catch(_) {}
  }
  Future<void> loadToday() async {
    try { final r = await _client.get('/musician/play/today'); todayData.value = Map.from(r.data['data'] ?? {}); } catch(_) {}
  }
  Future<void> loadBean() async {
    try { final r = await _client.get('/musician/cloudbean'); cloudbean.value = r.data['data']?['cloudbean'] ?? 0; } catch(_) {}
  }
  Future<void> loadTasks() async {
    try { final r = await _client.get('/musician/task'); tasks.assignAll((r.data['data'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
  }

  Future<void> obtainBean() async {
    try { final r = await _client.post('/musician/cloudbean/obtain'); if (r.data['code'] == 200) loadBean(); } catch(_) {}
  }
}
