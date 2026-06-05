import 'package:get/get.dart';
import 'listentogether_controller.dart';
class ListentogetherBinding extends Bindings { @override void dependencies() { Get.lazyPut(() => ListentogetherController(), fenix: true); } }
