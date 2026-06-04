import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'comment_controller.dart';

/// 评论页面
/// 可独立使用，也可嵌入到其他页面
class CommentPage extends StatelessWidget {
  final int resourceId;
  final int resourceType;
  final String? threadId;
  final String? title;

  const CommentPage({
    super.key,
    required this.resourceId,
    required this.resourceType,
    this.threadId,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // 初始化控制器
    final controller = Get.put(
      CommentController(
        resourceId: resourceId,
        resourceType: resourceType,
        threadId: threadId,
      ),
      tag: 'comment_${resourceType}_$resourceId',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title ?? '评论'),
        actions: [
          // 排序切换
          PopupMenuButton<int>(
            icon: const Icon(Icons.sort),
            onSelected: (type) => controller.changeSortType(type),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 1, child: Text('推荐')),
              const PopupMenuItem(value: 2, child: Text('最热')),
              const PopupMenuItem(value: 3, child: Text('最新')),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () => controller.refresh(),
          child: CustomScrollView(
            slivers: [
              // 热门评论
              if (controller.hotComments.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      '精彩评论 (${controller.hotComments.length})',
                      style: AppTextStyles.h3,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _buildCommentItem(controller, controller.hotComments[i]),
                    childCount: controller.hotComments.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextButton(
                      onPressed: () => controller.loadMoreHot(),
                      child: const Text('加载更多精彩评论'),
                    ),
                  ),
                ),
              ],

              // 最新评论
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    '最新评论 (${controller.newComments.length})',
                    style: AppTextStyles.h3,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    if (i >= controller.newComments.length - 5) {
                      controller.loadMoreNew();
                    }
                    return _buildCommentItem(controller, controller.newComments[i]);
                  },
                  childCount: controller.newComments.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),
      // 发送评论
      bottomNavigationBar: _buildInputBar(controller),
    );
  }

  /// 构建评论项
  Widget _buildCommentItem(CommentController controller, Map<String, dynamic> comment) {
    final user = comment['user'] ?? {};
    final isLiked = comment['liked'] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surface,
            backgroundImage: user['avatarUrl'] != null
                ? NetworkImage('${user['avatarUrl']}?param=72x72')
                : null,
          ),
          const SizedBox(width: 12),
          // 内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户名和时间
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user['nickname'] ?? '',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      Formatters.relativeTime(comment['time'] ?? 0),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // 评论内容
                Text(
                  comment['content'] ?? '',
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                ),
                // 回复
                if (comment['beReplied']?.isNotEmpty == true)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '@${comment['beReplied'][0]['user']?['nickname']}: ${comment['beReplied'][0]['content'] ?? ''}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // 点赞
                GestureDetector(
                  onTap: () => controller.toggleLike(
                    comment['commentId'] ?? 0,
                    isLiked: isLiked,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isLiked ? AppColors.accent : AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        Formatters.number(comment['likedCount'] ?? 0),
                        style: AppTextStyles.caption.copyWith(
                          color: isLiked ? AppColors.accent : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建输入框
  Widget _buildInputBar(CommentController controller) {
    final textController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.glassBorder, width: 0.5)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: textController,
                  style: AppTextStyles.bodySmall,
                  decoration: InputDecoration(
                    hintText: '发一条友善的评论',
                    hintStyle: AppTextStyles.caption,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                final text = textController.text.trim();
                if (text.isNotEmpty) {
                  final success = await controller.sendComment(text);
                  if (success) textController.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '发送',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
