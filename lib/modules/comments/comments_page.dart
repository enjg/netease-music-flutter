import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'comments_controller.dart';

class CommentsPage extends GetView<CommentsController> {
  const CommentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Obx(() => Text('评论 (${controller.total.value})'))),
      body: Column(children: [
        // Tab
        Obx(() => Row(children: [
          _tab('hot', '推荐'), _tab('new', '最新'),
        ])),
        // 列表
        Expanded(child: Obx(() {
          if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          final list = controller.currentTab.value == 'hot' ? controller.hotComments : controller.newComments;
          if (list.isEmpty) return const Center(child: Text('暂无评论', style: TextStyle(color: AppColors.textTertiary)));
          return ListView.builder(itemCount: list.length, itemBuilder: (_, i) => _commentItem(list[i]));
        })),
        // 输入框
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
          decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.glassBorder, width: 0.5))),
          child: Row(children: [
            Expanded(child: Container(
              height: 40, padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
              alignment: Alignment.centerLeft,
              child: const Text('发一条友善的评论', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            )),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _showSendDialog(context),
              child: const Icon(Icons.send_rounded, color: AppColors.accent, size: 22),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _tab(String key, String label) {
    final active = controller.currentTab.value == key;
    return GestureDetector(
      onTap: () => controller.switchTab(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: active ? AppColors.accent : Colors.transparent, width: 2)),
        ),
        child: Text(label, style: TextStyle(fontSize: 14, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? AppColors.textPrimary : AppColors.textTertiary)),
      ),
    );
  }

  Widget _commentItem(Map c) {
    final user = c['user'] ?? {};
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(radius: 18, backgroundColor: AppColors.surface,
          backgroundImage: user['avatarUrl'] != null ? NetworkImage('${user['avatarUrl']}?param=72x72') : null,
          child: user['avatarUrl'] == null ? const Icon(Icons.person, size: 18, color: AppColors.textTertiary) : null),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(user['nickname'] ?? '', style: AppTextStyles.caption),
            const Spacer(),
            Text(Formatters.number(c['likedCount'] ?? 0), style: AppTextStyles.caption),
            const SizedBox(width: 2),
            const Icon(Icons.favorite_border_rounded, size: 14, color: AppColors.textTertiary),
          ]),
          const SizedBox(height: 6),
          Text(c['content'] ?? '', style: AppTextStyles.bodySmall.copyWith(height: 1.5)),
          if (c['beReplied'] != null && (c['beReplied'] as List).isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(8)),
              child: Text('@${c['beReplied'][0]['user']?['nickname']}: ${c['beReplied'][0]['content'] ?? ''}', style: AppTextStyles.caption),
            ),
          const SizedBox(height: 6),
          Text(c['timeStr'] ?? '', style: AppTextStyles.caption),
        ])),
      ]),
    );
  }

  void _showSendDialog(BuildContext context) {
    final textCtrl = TextEditingController();
    Get.dialog(AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('发表评论', style: TextStyle(color: AppColors.textPrimary)),
      content: TextField(controller: textCtrl, style: const TextStyle(color: AppColors.textPrimary),
        decoration: const InputDecoration(hintText: '写点什么...', hintStyle: TextStyle(color: AppColors.textTertiary)), maxLines: 3),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('取消')),
        TextButton(onPressed: () async {
          if (textCtrl.text.isNotEmpty) { await controller.sendComment(textCtrl.text); Get.back(); }
        }, child: const Text('发送', style: TextStyle(color: AppColors.accent))),
      ],
    ));
  }
}
