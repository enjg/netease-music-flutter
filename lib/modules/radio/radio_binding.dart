import 'package:get/get.dart';
import 'radio_controller.dart';

class RadioBinding extends Bindings {
  @override
  void dependencies() { Get.lazyPut(() => RadioController()); }
}
