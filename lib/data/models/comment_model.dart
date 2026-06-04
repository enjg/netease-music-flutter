/// 评论数据模型
class CommentModel {
  final int commentId;
  final String content;
  final int time;
  final String timeStr;
  final int likedCount;
  final bool liked;
  final CommentUser user;
  final List<CommentReply> beReplied;

  const CommentModel({
    required this.commentId,
    required this.content,
    required this.time,
    this.timeStr = '',
    this.likedCount = 0,
    this.liked = false,
    required this.user,
    this.beReplied = const [],
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] ?? 0,
      content: json['content'] ?? '',
      time: json['time'] ?? 0,
      timeStr: json['timeStr'] ?? '',
      likedCount: json['likedCount'] ?? 0,
      liked: json['liked'] ?? false,
      user: CommentUser.fromJson(json['user'] ?? {}),
      beReplied: (json['beReplied'] as List?)
              ?.map((r) => CommentReply.fromJson(r))
              .toList() ?? [],
    );
  }
}

class CommentUser {
  final int userId;
  final String nickname;
  final String avatarUrl;
  final int vipType;

  const CommentUser({
    required this.userId,
    required this.nickname,
    this.avatarUrl = '',
    this.vipType = 0,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) => CommentUser(
    userId: json['userId'] ?? 0,
    nickname: json['nickname'] ?? '',
    avatarUrl: json['avatarUrl'] ?? '',
    vipType: json['vipType'] ?? 0,
  );
}

class CommentReply {
  final String content;
  final CommentUser user;

  const CommentReply({required this.content, required this.user});

  factory CommentReply.fromJson(Map<String, dynamic> json) => CommentReply(
    content: json['content'] ?? '',
    user: CommentUser.fromJson(json['user'] ?? {}),
  );
}
