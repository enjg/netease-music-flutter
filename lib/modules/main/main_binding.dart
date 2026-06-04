import 'package:get/get.dart';
import 'main_controller.dart';
import '../home/home_controller.dart';
import '../podcast/podcast_controller.dart';
import '../mine/mine_controller.dart';
import '../follow/follow_controller.dart';
import '../account/account_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PodcastController());
    Get.lazyPut(() => MineController());
    Get.lazyPut(() => FollowController());
    Get.lazyPut(() => AccountController());
  }
}
