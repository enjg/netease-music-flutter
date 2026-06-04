import 'package:get/get.dart';
import 'live_controller.dart';
class LiveBinding extends Bindings { @override void dependencies() { Get.lazyPut(() => LiveController()); } }
