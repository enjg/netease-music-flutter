import 'package:get/get.dart';
import 'comments_controller.dart';
class CommentsBinding extends Bindings { @override void dependencies() { Get.lazyPut(() => CommentsController(), fenix: true); } }
