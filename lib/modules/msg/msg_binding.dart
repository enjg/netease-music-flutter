import 'package:get/get.dart';
import 'msg_controller.dart';

class MsgBinding extends Bindings {
  @override
  void dependencies() { Get.lazyPut(() => MsgController()); }
}
