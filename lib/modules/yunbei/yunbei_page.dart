import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/formatters.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import 'yunbei_controller.dart';

class YunbeiPage extends GetView<YunbeiController> {
  const YunbeiPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('云贝中心')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
          // 余额卡片
          Container(
            width: double.infinity, padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0x26F5A623), Color(0x14EC4141)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x33F5A623), width: 0.5),
            ),
            child: Column(children: [
              const Text('云贝余额', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Text('${controller.balance.value}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFFF5A623))),
              const SizedBox(height: 8),
              const Text('听歌、签到、完成任务可获得云贝', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _button('✨ 签到领云贝', true, () => controller.doSign()),
                const SizedBox(width: 10),
                _button('收支明细', false, () => Get.showSnackbar(GetSnackBar(message: '收支明细页面开发中', duration: const Duration(seconds: 1), backgroundColor: const Color(0xE6222222), margin: const EdgeInsets.all(16), borderRadius: 12))),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          // 签到
          _signCard(),
          const SizedBox(height: 16),
          // 任务
          _sectionTitle('每日任务'),
          ...controller.tasks.map((t) => _taskItem(t)),
          // 默认任务
          if (controller.tasks.isEmpty) ...[
            _defaultTask('🎵', '听歌打卡', '今日听满30分钟', '+5☁️'),
            _defaultTask('📱', '分享歌曲', '分享一首歌曲到社交平台', '+3☁️'),
            _defaultTask('💬', '发表评论', '在任意歌曲下发表评论', '+2☁️'),
          ],
          // 记录
          _sectionTitle('收支记录'),
          ...controller.records.map((r) => _recordItem(r)),
          const SizedBox(height: 200),
        ]));
      }),
    );
  }

  Widget _button(String text, bool primary, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 36, padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: primary ? const Color(0xFFF5A623) : AppColors.glass,
        borderRadius: BorderRadius.circular(18),
        border: primary ? null : Border.all(color: AppColors.glassBorder, width: 0.5),
      ),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: primary ? const Color(0xFF1A1A1A) : AppColors.textPrimary)),
    ),
  );

  Widget _signCard() {
    final signed = controller.info.value['mobileSign'] == true || controller.info.value['pcSign'] == true;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0x26F5A623), borderRadius: BorderRadius.circular(12)),
          child: const Text('📅', style: TextStyle(fontSize: 20))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('每日签到', style: AppTextStyles.bodyMedium),
          Text(signed ? '今日已签到 ✓' : '今日未签到', style: AppTextStyles.caption),
        ])),
        Container(
          height: 34, padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: signed ? AppColors.surface : const Color(0x26F5A623), borderRadius: BorderRadius.circular(17)),
          alignment: Alignment.center,
          child: Text(signed ? '已签到' : '签到', style: TextStyle(fontSize: 12, color: signed ? AppColors.textTertiary : const Color(0xFFF5A623)))),
      ]),
    );
  }

  Widget _taskItem(Map t) {
    final done = (t['status'] ?? 0) == 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: const Text('🎯', style: TextStyle(fontSize: 18))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t['taskName'] ?? '任务', style: AppTextStyles.bodyMedium),
          Text(t['description'] ?? '', style: AppTextStyles.caption),
        ])),
        Text('+${t['score'] ?? 1}☁️', style: const TextStyle(fontSize: 12, color: Color(0xFFF5A623))),
        const SizedBox(width: 8),
        Container(height: 28, padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: done ? AppColors.surface : const Color(0x26F5A623), borderRadius: BorderRadius.circular(14)),
          alignment: Alignment.center,
          child: Text(done ? '已完成' : '去完成', style: TextStyle(fontSize: 11, color: done ? AppColors.textTertiary : const Color(0xFFF5A623)))),
      ]),
    );
  }

  Widget _defaultTask(String icon, String name, String desc, String reward) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Text(icon, style: const TextStyle(fontSize: 18))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: AppTextStyles.bodyMedium), Text(desc, style: AppTextStyles.caption),
      ])),
      Text(reward, style: const TextStyle(fontSize: 12, color: Color(0xFFF5A623))),
      const SizedBox(width: 8),
      Container(height: 28, padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: const Color(0x26F5A623), borderRadius: BorderRadius.circular(14)),
        alignment: Alignment.center,
        child: const Text('去完成', style: TextStyle(fontSize: 11, color: Color(0xFFF5A623)))),
    ]),
  );

  Widget _recordItem(Map r) {
    final positive = (r['yunbei'] ?? 0) > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(50)),
          child: Text(positive ? '💰' : '📤', style: const TextStyle(fontSize: 16))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(r['description'] ?? '云贝变动', style: AppTextStyles.bodySmall),
          Text(Formatters.relativeTime(r['time'] ?? 0), style: AppTextStyles.caption),
        ])),
        Text('${positive ? '+' : ''}${r['yunbei'] ?? 0}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: positive ? const Color(0xFFF5A623) : AppColors.textTertiary)),
      ]),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: AppTextStyles.h3)]),
  );
}
