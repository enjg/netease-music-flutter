import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class MessagesController extends GetxController {
  final _client = ApiClient();
  final privateMsgs = <Map<String, dynamic>>[].obs;
  final commentMsgs = <Map<String, dynamic>>[].obs;
  final forwardMsgs = <Map<String, dynamic>>[].obs;
  final notices = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override void onInit() { super.onInit(); loadAll(); }

  Future<void> loadAll() async {
    isLoading.value = true;
    try {
      await Future.wait([loadPrivate(), loadComments(), loadForwards(), loadNotices()]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadPrivate() async {
    try { final r = await _client.get('/msg/private', queryParameters: {'limit': 30}); privateMsgs.assignAll((r.data['msgs'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
  }
  Future<void> loadComments() async {
    try { final r = await _client.get('/msg/comments', queryParameters: {'limit': 20}); commentMsgs.assignAll((r.data['comments'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
  }
  Future<void> loadForwards() async {
    try { final r = await _client.get('/msg/forwards', queryParameters: {'limit': 20}); forwardMsgs.assignAll((r.data['forwards'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
  }
  Future<void> loadNotices() async {
    try { final r = await _client.get('/msg/notices', queryParameters: {'limit': 10}); notices.assignAll((r.data['notices'] ?? []).cast<Map<String, dynamic>>()); } catch(_) {}
  }
}
