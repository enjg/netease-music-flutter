import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'messages_controller.dart';

class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('消息')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        return SingleChildScrollView(child: Column(children: [
          // 入口网格
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _entry('💬', '评论', controller.commentMsgs.length),
              _entry('@', '@我', controller.forwardMsgs.length),
              _entry('✉️', '私信', controller.privateMsgs.length),
              _entry('🔔', '通知', controller.notices.length),
            ]),
          ),
          // 私信列表
          _sectionTitle('私信'),
          ...controller.privateMsgs.map((m) {
            final from = m['fromUser'] ?? {};
            final last = m['lastMsg'] ?? {};
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                CircleAvatar(radius: 24, backgroundColor: AppColors.surface,
                  backgroundImage: from['avatarUrl'] != null ? NetworkImage('${from['avatarUrl']}?param=96x96') : null,
                  child: from['avatarUrl'] == null ? const Icon(Icons.person, size: 24, color: AppColors.textTertiary) : null),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(from['nickname'] ?? '', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(last['msg'] ?? '', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                Column(children: [
                  Text(Formatters.relativeTime(last['time'] ?? 0), style: AppTextStyles.caption),
                  if ((m['newMsgCount'] ?? 0) > 0) Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(9)),
                    child: Text('${m['newMsgCount']}', style: const TextStyle(fontSize: 10, color: Colors.white))),
                ]),
              ]),
            );
          }),
          // 通知
          _sectionTitle('通知'),
          ...controller.notices.map((n) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Text('🔔', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                const Text('系统通知', style: AppTextStyles.bodySmall),
                const Spacer(),
                Text(Formatters.relativeTime(n['time'] ?? 0), style: AppTextStyles.caption),
              ]),
              const SizedBox(height: 8),
              Text(n['content'] ?? n['message'] ?? '您有一条新通知', style: AppTextStyles.bodySmall.copyWith(height: 1.5)),
            ]),
          )),
          const SizedBox(height: 200),
        ]));
      }),
    );
  }

  Widget _entry(String icon, String label, int count) => Column(children: [
    Stack(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
        child: Center(child: Text(icon, style: const TextStyle(fontSize: 22)))),
      if (count > 0) Positioned(top: 0, right: 0, child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(9)),
        child: Text('$count', style: const TextStyle(fontSize: 9, color: Colors.white)))),
    ]),
    const SizedBox(height: 6),
    Text(label, style: AppTextStyles.caption),
  ]);

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: AppTextStyles.h3),
      const Text('查看全部 ›', style: AppTextStyles.caption),
    ]),
  );
}
