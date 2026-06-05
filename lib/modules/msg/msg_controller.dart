import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class MsgController extends GetxController {
  final _client = ApiClient();
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final toUserId = 0.obs;

  String? get uid => Get.arguments?['uid'];
  String? get nickname => Get.arguments?['nickname'];

  @override
  void onInit() {
    super.onInit();
    if (uid != null) { toUserId.value = int.tryParse(uid!) ?? 0; loadMessages(); }
  }

  Future<void> loadMessages() async {
    isLoading.value = true;
    try {
      final r = await _client.get('/msg/private/history', queryParameters: {'uid': toUserId.value});
      messages.assignAll((r.data['msgs'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> sendMsg(String text) async {
    try {
      await _client.get('/send/text', queryParameters: {'user_ids': toUserId.value, 'msg': text});
      await loadMessages();
    } catch (_) {}
  }
}
