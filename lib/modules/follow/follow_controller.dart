import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class FollowController extends GetxController {
  final _client = ApiClient();
  final events = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final hasMore = true.obs;
  int _lastTime = 0;

  @override
  void onInit() { super.onInit(); loadEvents(); }

  Future<void> loadEvents({bool refresh = false}) async {
    if (refresh) { _lastTime = 0; events.clear(); }
    isLoading.value = true;
    try {
      final r = await _client.get('/event', queryParameters: {'pagesize': 20, if (_lastTime > 0) 'lasttime': _lastTime});
      final list = (r.data['events'] ?? []).cast<Map<String, dynamic>>();
      if (list.isNotEmpty) {
        _lastTime = list.last['eventTime'] ?? 0;
        events.addAll(list);
      }
      hasMore.value = r.data['more'] ?? false;
    } catch (_) {} finally { isLoading.value = false; }
  }

  Future<void> forwardEvent(int id, String msg) async {
    try { await _client.post('/event/forward', queryParameters: {'id': id, 'forwards': msg}); } catch (_) {}
  }

  Future<void> commentEvent(int id, String msg) async {
    try { await _client.post('/event/comment', queryParameters: {'threadId': 'A_EV_2_$id', 'content': msg}); } catch (_) {}
  }

  Future<void> deleteEvent(int id) async {
    try {
      await _client.post('/event/del', queryParameters: {'id': id});
      events.removeWhere((e) => e['id'] == id);
    } catch (_) {}
  }
}
