import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../shared/services/auth_service.dart';
import '../../app/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // 等待认证初始化完成（含匿名登录）
    final auth = Get.find<AuthService>();
    // 最多等5秒
    for (int i = 0; i < 50; i++) {
      if (!auth.isLoading.value) break;
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (mounted) {
      Get.offAllNamed(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.music_note_rounded, size: 64, color: AppColors.accent),
            SizedBox(height: 16),
            Text('网易云音乐', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
            )),
            SizedBox(height: 8),
            Text('音乐的力量', style: TextStyle(
              fontSize: 13, color: AppColors.textTertiary,
            )),
          ],
        ),
      ),
    );
  }
}
