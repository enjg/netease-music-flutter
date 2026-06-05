import 'package:get/get.dart';
import 'follow_controller.dart';
class FollowBinding extends Bindings {
  @override void dependencies() { Get.lazyPut(() => FollowController(), fenix: true); }
}
