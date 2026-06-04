import 'package:get/get.dart';
import 'comment_controller.dart';

class CommentBinding extends Bindings {
  @override
  void dependencies() {
    // 评论控制器在页面创建时动态初始化
    // 不在这里注册，因为需要传入 resourceId 和 resourceType
  }
}
