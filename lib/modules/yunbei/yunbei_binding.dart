import 'package:get/get.dart';
import 'yunbei_controller.dart';
class YunbeiBinding extends Bindings { @override void dependencies() { Get.lazyPut(() => YunbeiController(), fenix: true); } }
