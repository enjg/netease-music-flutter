import 'package:get/get.dart';
import 'mv_controller.dart';

class MvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MvController(), fenix: true);
  }
}
