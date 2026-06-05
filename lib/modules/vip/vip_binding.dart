import 'package:get/get.dart';
import 'vip_controller.dart';

class VipBinding extends Bindings {
  @override
  void dependencies() { Get.lazyPut(() => VipController()); }
}
