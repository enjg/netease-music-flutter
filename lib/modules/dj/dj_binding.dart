import 'package:get/get.dart';
import 'dj_controller.dart';

class DjBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DjController(), fenix: true);
  }
}
