import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'msg_controller.dart';

class MsgPage extends GetView<MsgController> {
  const MsgPage({super.key});
  @override
  Widget build(BuildContext context) {
    final msgCtrl = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(controller.nickname ?? '私信')),
      body: Column(children: [
        Expanded(child: Obx(() {
          if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: controller.messages.length,
            itemBuilder: (_, i) {
              final m = controller.messages[controller.messages.length - 1 - i];
              final fromUser = m['fromUser'] ?? {};
              final isMe = fromUser['userId']?.toString() != controller.uid;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.accent : AppColors.glass,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(m['msg'] ?? m['content'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              );
            },
          );
        })),
        // 输入栏
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
          decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.glassBorder, width: 0.5))),
          child: Row(children: [
            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(20)),
              child: TextField(controller: msgCtrl, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(hintText: '发消息...', hintStyle: TextStyle(color: AppColors.textTertiary), border: InputBorder.none, isDense: true)),
            )),
            const SizedBox(width: 8),
            GestureDetector(onTap: () { if (msgCtrl.text.isNotEmpty) { controller.sendMsg(msgCtrl.text); msgCtrl.clear(); } },
              child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.send, size: 18, color: Colors.white))),
          ]),
        ),
      ]),
    );
  }
}
