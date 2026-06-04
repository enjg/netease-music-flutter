import 'package:get/get.dart';
import '../../shared/services/auth_service.dart';
import '../../core/network/api_client.dart';
import '../../app/routes.dart';

class LoginController extends GetxController {
  final authService = Get.find<AuthService>();
  final phone = ''.obs;
  final code = ''.obs;
  final agreed = false.obs;
  final isLoading = false.obs;
  final countdown = 0.obs;

  void sendCaptcha() async {
    if (phone.value.length < 11) return;
    final ok = await Get.find<ApiClient>().post('/captcha/sent', queryParameters: {'phone': phone.value}).then((r) => r.data['code'] == 200).catchError((_) => false);
    if (ok) {
      countdown.value = 60;
      _startCountdown();
    }
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      countdown.value--;
      return countdown.value > 0;
    });
  }

  void login() async {
    if (!agreed.value || phone.value.length < 11 || code.value.length < 4) return;
    isLoading.value = true;
    final ok = await authService.loginByPhone(phone.value, code.value);
    isLoading.value = false;
    if (ok) Get.offAllNamed(AppRoutes.main);
  }
}
