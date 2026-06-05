import 'package:get/get.dart';
import 'recent_play_controller.dart';

class RecentPlayBinding extends Bindings {
  @override
  void dependencies() { Get.lazyPut(() => RecentPlayController()); }
}
