import 'package:get/get.dart';
import '../../data/providers/comment_provider.dart';

/// 通用评论控制器
/// 可用于歌曲、专辑、歌单、MV、电台、视频等资源的评论
class CommentController extends GetxController {
  final _provider = CommentProvider();

  // 评论数据
  final hotComments = <Map<String, dynamic>>[].obs;
  final newComments = <Map<String, dynamic>>[].obs;

  // 加载状态
  final isLoading = true.obs;
  final isLoadingMore = false.obs;

  // 资源信息
  final int resourceId;
  final int resourceType; // 0歌曲 1动态 2歌单 3专辑 4电台 5视频
  final String? threadId;

  // 排序方式 (1推荐 2最热 3时间)
  final sortType = 1.obs;

  // 分页
  int _hotOffset = 0;
  int _newOffset = 0;

  CommentController({
    required this.resourceId,
    required this.resourceType,
    this.threadId,
  });

  @override
  void onInit() {
    super.onInit();
    loadComments();
  }

  /// 加载评论
  Future<void> loadComments() async {
    isLoading.value = true;
    try {
      await Future.wait([loadHotComments(), loadNewComments()]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载热门评论
  Future<void> loadHotComments() async {
    try {
      final data = await _provider.getHotComments(
        id: resourceId,
        type: resourceType,
        limit: 10,
      );
      hotComments.assignAll((data['hotComments'] ?? []).cast<Map<String, dynamic>>());
      _hotOffset = hotComments.length;
    } catch (_) {}
  }

  /// 加载最新评论
  Future<void> loadNewComments() async {
    try {
      final data = await _provider.getNewComments(
        id: resourceId,
        type: resourceType,
        sortType: sortType.value,
        limit: 20,
      );
      newComments.assignAll((data['comments'] ?? []).cast<Map<String, dynamic>>());
      _newOffset = newComments.length;
    } catch (_) {}
  }

  /// 加载更多热门评论
  Future<void> loadMoreHot() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getHotComments(
        id: resourceId,
        type: resourceType,
        limit: 10,
        offset: _hotOffset,
      );
      final more = (data['hotComments'] ?? []).cast<Map<String, dynamic>>();
      hotComments.addAll(more);
      _hotOffset = hotComments.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 加载更多最新评论
  Future<void> loadMoreNew() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getNewComments(
        id: resourceId,
        type: resourceType,
        sortType: sortType.value,
        limit: 20,
        offset: _newOffset,
      );
      final more = (data['comments'] ?? []).cast<Map<String, dynamic>>();
      newComments.addAll(more);
      _newOffset = newComments.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 点赞/取消点赞评论
  Future<void> toggleLike(int commentId, {bool isLiked = false}) async {
    try {
      await _provider.likeComment(
        t: isLiked ? 0 : 1,
        type: resourceType,
        id: resourceId,
        cid: commentId,
        threadId: threadId,
      );
      // 更新本地状态
      _updateLikeStatus(hotComments, commentId, isLiked);
      _updateLikeStatus(newComments, commentId, isLiked);
    } catch (_) {}
  }

  /// 发送评论
  Future<bool> sendComment(String content) async {
    try {
      await _provider.sendComment(
        t: 1,
        type: resourceType,
        id: resourceId,
        content: content,
        threadId: threadId,
      );
      // 重新加载评论
      await loadComments();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 删除评论
  Future<bool> deleteComment(int commentId) async {
    try {
      await _provider.sendComment(
        t: 0,
        type: resourceType,
        id: resourceId,
        commentId: commentId,
      );
      // 重新加载评论
      await loadComments();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 切换排序方式
  void changeSortType(int type) {
    sortType.value = type;
    loadNewComments();
  }

  /// 刷新评论
  Future<void> refresh() async {
    _hotOffset = 0;
    _newOffset = 0;
    await loadComments();
  }

  /// 更新点赞状态
  void _updateLikeStatus(
    RxList<Map<String, dynamic>> list,
    int commentId,
    bool isLiked,
  ) {
    final index = list.indexWhere((c) => c['commentId'] == commentId);
    if (index != -1) {
      final comment = Map<String, dynamic>.from(list[index]);
      comment['liked'] = !isLiked;
      comment['likedCount'] = (comment['likedCount'] ?? 0) + (isLiked ? -1 : 1);
      list[index] = comment;
    }
  }
}
