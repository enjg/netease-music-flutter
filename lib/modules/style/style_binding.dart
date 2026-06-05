import 'package:get/get.dart';
import 'style_controller.dart';
class StyleBinding extends Bindings { @override void dependencies() { Get.lazyPut(() => StyleController(), fenix: true); } }
