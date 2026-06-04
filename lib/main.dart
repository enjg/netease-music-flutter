import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/storage/local_storage.dart';
import 'shared/services/auth_service.dart';
import 'shared/services/player_service.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await LocalStorage.init();

  // 注册全局服务
  Get.put(AuthService(), permanent: true);
  Get.put(PlayerService(), permanent: true);

  runApp(const NetEaseMusicApp());
}
