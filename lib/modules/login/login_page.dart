import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../config/theme/app_dimensions.dart';
import '../../shared/services/auth_service.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Get.back(),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Logo
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.accent, Color(0xFFFF6B6B)]),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 32)],
              ),
              child: const Icon(Icons.music_note_rounded, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('网易云音乐', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Obx(() {
              final auth = Get.find<AuthService>();
              if (auth.isAnonymous.value) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('当前为游客模式', style: TextStyle(fontSize: 12, color: AppColors.accent)),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 40),

            // 手机号
            TextField(
              onChanged: (v) => controller.phone.value = v,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: '请输入手机号'),
            ),
            const SizedBox(height: 16),

            // 验证码
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => controller.code.value = v,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(hintText: '请输入验证码'),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() => GestureDetector(
                  onTap: controller.countdown.value > 0 ? null : controller.sendCaptcha,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      controller.countdown.value > 0 ? '${controller.countdown.value}s' : '获取验证码',
                      style: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 24),

            // 协议
            Obx(() => Row(
              children: [
                GestureDetector(
                  onTap: () => controller.agreed.value = !controller.agreed.value,
                  child: Container(
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.agreed.value ? AppColors.accent : Colors.transparent,
                      border: Border.all(
                        color: controller.agreed.value ? AppColors.accent : AppColors.textTertiary,
                        width: 1.5,
                      ),
                    ),
                    child: controller.agreed.value
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(TextSpan(
                    style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                    children: [
                      const TextSpan(text: '我已阅读并同意 '),
                      TextSpan(text: '《服务条款》', style: TextStyle(color: AppColors.accent.withOpacity(0.8))),
                      const TextSpan(text: '、'),
                      TextSpan(text: '《隐私政策》', style: TextStyle(color: AppColors.accent.withOpacity(0.8))),
                    ],
                  )),
                ),
              ],
            )),
            const SizedBox(height: 32),

            // 登录按钮
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.login,
              child: controller.isLoading.value
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('登 录'),
            )),
            const SizedBox(height: 16),

            // 跳过 / 继续游客模式
            GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '继续使用游客模式',
                  style: TextStyle(fontSize: 13, color: AppColors.textTertiary.withOpacity(0.7)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
