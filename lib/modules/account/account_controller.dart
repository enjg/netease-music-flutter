import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../shared/services/auth_service.dart';

class AccountController extends GetxController {
  final _client = ApiClient();
  final authService = Get.find<AuthService>();
  final vipInfo = Rx<Map<String, dynamic>>({});
  final growthPoint = Rx<Map<String, dynamic>>({});
  final msgCount = 0.obs;

  @override
  void onInit() { super.onInit(); loadVipInfo(); loadMsgCount(); }

  Future<void> loadVipInfo() async {
    try {
      final r = await _client.get('/vip/info');
      vipInfo.value = Map.from(r.data['data'] ?? {});
    } catch (_) {}
    try {
      final r = await _client.get('/vip/growthpoint');
      growthPoint.value = Map.from(r.data['data'] ?? {});
    } catch (_) {}
  }

  Future<void> loadMsgCount() async {
    try {
      final r = await _client.get('/msg/private', queryParameters: {'limit': 1});
      final msgs = (r.data['msgs'] ?? []) as List;
      msgCount.value = msgs.fold(0, (s, m) => s + (m['newMsgCount'] ?? 0) as int);
    } catch (_) {}
  }

  Future<void> logout() async {
    await authService.logout();
    Get.offAllNamed('/main');
  }
}
