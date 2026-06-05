import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../shared/services/auth_service.dart';
import 'follow_controller.dart';

class FollowPage extends GetView<FollowController> {
  const FollowPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final auth = Get.find<AuthService>();
        if (!auth.isLoggedIn.value) return _buildLoginPrompt();
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 16),
            child: Row(children: [
              const Text('关注', style: AppTextStyles.h1),
              const Spacer(),
              IconButton(icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.textSecondary), onPressed: () => Get.toNamed('/search')),
            ]),
          )),
          if (controller.isLoading.value && controller.events.isEmpty)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppColors.accent)))
          else if (controller.events.isEmpty)
            const SliverFillRemaining(child: Center(child: Text('暂无动态', style: TextStyle(color: AppColors.textTertiary))))
          else
            SliverList(delegate: SliverChildBuilderDelegate((_, i) {
              if (i >= controller.events.length) {
                if (controller.hasMore.value) { controller.loadEvents(); return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: AppColors.accent))); }
                return const SizedBox(height: 200);
              }
              return _eventItem(controller.events[i]);
            }, childCount: controller.events.length + 1)),
        ]);
      }),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('👥', style: TextStyle(fontSize: 48)),
      const SizedBox(height: 16),
      const Text('登录后查看好友动态', style: AppTextStyles.bodyLarge),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () => Get.toNamed('/login'), child: const Text('立即登录')),
    ]));
  }

  Widget _eventItem(Map e) {
    final user = e['user'] ?? {};
    final info = e['info'] ?? {};
    Map json = {};
    try { json = Map.from(_parseJson(e['json'] ?? '{}')); } catch (_) {}

    String typeTag = '';
    final type = e['type'] ?? 0;
    if (type == 18) typeTag = '分享单曲';
    else if (type == 19) typeTag = '分享歌单';
    else if (type == 22) typeTag = '转发';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 头部
        Row(children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.surface,
            backgroundImage: user['avatarUrl'] != null ? NetworkImage('${user['avatarUrl']}?param=72x72') : null,
            child: user['avatarUrl'] == null ? const Icon(Icons.person, size: 18, color: AppColors.textTertiary) : null),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user['nickname'] ?? '', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
            Text(Formatters.relativeTime(e['showTime'] ?? 0), style: AppTextStyles.caption),
          ])),
          if (typeTag.isNotEmpty) Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(4)),
            child: Text(typeTag, style: AppTextStyles.caption)),
        ]),
        // 内容
        if (json['msg']?.toString().isNotEmpty == true)
          Padding(padding: const EdgeInsets.only(top: 10), child:
            Text(json['msg'].toString(), style: AppTextStyles.bodyMedium)),
        // 歌曲资源
        if (json['song'] != null)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(8), child:
                Container(width: 44, height: 44, color: AppColors.surface,
                  child: Image.network('${json['song']['album']?['picUrl'] ?? ''}?param=88x88', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: AppColors.textTertiary, size: 20)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(json['song']['name'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text((json['song']['artists'] as List?)?.map((a) => a['name']).join('/') ?? '', style: AppTextStyles.caption),
              ])),
            ]),
          ),
        // 操作栏
        Padding(padding: const EdgeInsets.only(top: 10), child: Row(children: [
          _action(Icons.chat_bubble_outline_rounded, '${info['commentCount'] ?? 0}'),
          const SizedBox(width: 24),
          _action(Icons.repeat_rounded, '${info['shareCount'] ?? 0}'),
          const SizedBox(width: 24),
          _action(Icons.favorite_border_rounded, '${info['likedCount'] ?? 0}'),
        ])),
        const Divider(height: 24, color: AppColors.glassBorder),
      ]),
    );
  }

  Widget _action(IconData icon, String count) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 16, color: AppColors.textTertiary),
    const SizedBox(width: 4),
    Text(count, style: AppTextStyles.caption),
  ]);

  dynamic _parseJson(String s) {
    try { return jsonDecode(s); } catch (_) { return {}; }
  }
}
