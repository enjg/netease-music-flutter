import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../shared/services/auth_service.dart';

class VipController extends GetxController {
  final _client = ApiClient();
  final authService = Get.find<AuthService>();
  final vipInfo = Rx<Map<String, dynamic>>({});
  final vipProducts = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() { super.onInit(); loadData(); }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final r = await _client.get('/vip/info');
      vipInfo.value = Map.from(r.data['data'] ?? r.data);
    } catch (_) {}
    isLoading.value = false;
  }
}
