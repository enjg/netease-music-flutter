import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'account_controller.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('账号')),
      body: Obx(() {
        final user = controller.authService.user.value;
        final isLoggedIn = controller.authService.isLoggedIn.value;
        return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
          // 用户卡片
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0x1AEC4141), Color(0x106464FF)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.glassBorder, width: 0.5),
            ),
            child: Column(children: [
              CircleAvatar(radius: 36, backgroundColor: AppColors.surface,
                backgroundImage: user.avatarUrl.isNotEmpty ? NetworkImage('${user.avatarUrl}?param=144x144') : null,
                child: user.avatarUrl.isEmpty ? const Icon(Icons.person, size: 36, color: AppColors.textTertiary) : null),
              const SizedBox(height: 12),
              Text(isLoggedIn ? user.nickname : '未登录', style: AppTextStyles.h3),
              if (user.signature.isNotEmpty)
                Padding(padding: const EdgeInsets.only(top: 4), child: Text(user.signature, style: AppTextStyles.caption)),
              if (isLoggedIn) Padding(padding: const EdgeInsets.only(top: 4), child: Text('UID: ${user.userId}', style: AppTextStyles.caption)),
            ]),
          ),
          const SizedBox(height: 16),
          // 统计
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat(Formatters.number(user.follows), '关注'),
              _stat(Formatters.number(user.followeds), '粉丝'),
              _stat('${user.level}', '等级'),
              _stat(Formatters.number(user.listenSongs), '听歌'),
            ]),
          ),
          const SizedBox(height: 16),
          // VIP
          if (controller.vipInfo.value['redVipLevel'] != null && controller.vipInfo.value['redVipLevel'] > 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0x1FF5A623), Color(0x14EC4141)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x26F5A623)),
              ),
              child: Row(children: [
                const Text('👑', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('VIP Lv.${controller.vipInfo.value['redVipLevel']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF5A623))),
                  const Text('享受高品质音乐', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0x26F5A623), borderRadius: BorderRadius.circular(15)),
                  child: const Text('续费', style: TextStyle(fontSize: 12, color: Color(0xFFF5A623)))),
              ]),
            ),
          const SizedBox(height: 16),
          // 功能列表
          _menuGroup([
            _menuItem(Icons.chat_bubble_outline_rounded, '我的消息', () => Get.toNamed('/messages'), badge: controller.msgCount.value),
            _menuItem(Icons.monetization_on_outlined, '云贝中心', () => Get.toNamed('/yunbei')),
            _menuItem(Icons.mic_rounded, '音乐人中心', () => Get.toNamed('/musician')),
          ]),
          const SizedBox(height: 12),
          _menuGroup([
            _menuItem(Icons.headphones_rounded, '一起听', () => Get.toNamed('/listentogether')),
            _menuItem(Icons.live_tv_rounded, '直播', () => Get.toNamed('/live')),
            _menuItem(Icons.palette_rounded, '风格', () => Get.toNamed('/style')),
          ]),
          const SizedBox(height: 12),
          _menuGroup([
            _menuItem(Icons.settings_outlined, '设置', () => Get.showSnackbar(GetSnackBar(message: '设置页面开发中', duration: const Duration(seconds: 1), backgroundColor: const Color(0xE6222222), margin: const EdgeInsets.all(16), borderRadius: 12))),
            _menuItem(Icons.help_outline_rounded, '帮助与反馈', () => Get.showSnackbar(GetSnackBar(message: '帮助与反馈页面开发中', duration: const Duration(seconds: 1), backgroundColor: const Color(0xE6222222), margin: const EdgeInsets.all(16), borderRadius: 12))),
          ]),
          if (isLoggedIn) ...[
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Get.dialog(AlertDialog(
                backgroundColor: AppColors.surface,
                title: const Text('退出登录', style: TextStyle(color: AppColors.textPrimary)),
                content: const Text('确认退出登录？', style: TextStyle(color: AppColors.textSecondary)),
                actions: [
                  TextButton(onPressed: () => Get.back(), child: const Text('取消')),
                  TextButton(onPressed: () { Get.back(); controller.logout(); }, child: const Text('确认', style: TextStyle(color: AppColors.accent))),
                ],
              )),
              child: Container(
                width: double.infinity, height: 48,
                decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
                alignment: Alignment.center,
                child: const Text('退出登录', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ),
            ),
          ],
          if (!isLoggedIn) ...[
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Get.toNamed('/login'), child: const Text('立即登录')),
          ],
          const SizedBox(height: 200),
        ]));
      }),
    );
  }

  Widget _stat(String num, String label) => Column(children: [
    Text(num, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    const SizedBox(height: 2),
    Text(label, style: AppTextStyles.caption),
  ]);

  Widget _menuGroup(List<Widget> items) => Container(
    decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
    clipBehavior: Clip.antiAlias,
    child: Column(children: items),
  );

  Widget _menuItem(IconData icon, String label, VoidCallback onTap, {int badge = 0}) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: AppColors.textPrimary)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
        if (badge > 0) Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(9)),
          child: Text('$badge', style: const TextStyle(fontSize: 10, color: Colors.white))),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textTertiary),
      ]),
    ),
  );
}
