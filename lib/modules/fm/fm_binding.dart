import 'package:get/get.dart';
import 'fm_controller.dart';

class FmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FmController());
  }
}
