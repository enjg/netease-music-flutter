/// 歌单数据模型
class PlaylistModel {
  final int id;
  final String name;
  final String coverUrl;
  final String description;
  final int trackCount;
  final int playCount;
  final int subscribedCount;
  final int commentCount;
  final int shareCount;
  final int creatorId;
  final String creatorName;
  final String creatorAvatar;
  final List<String> tags;
  final int createTime;

  const PlaylistModel({
    required this.id,
    required this.name,
    required this.coverUrl,
    this.description = '',
    this.trackCount = 0,
    this.playCount = 0,
    this.subscribedCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.creatorId = 0,
    this.creatorName = '',
    this.creatorAvatar = '',
    this.tags = const [],
    this.createTime = 0,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final creator = json['creator'] as Map<String, dynamic>? ?? {};
    return PlaylistModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      coverUrl: json['coverImgUrl'] ?? json['picUrl'] ?? '',
      description: json['description']?.toString() ?? '',
      trackCount: json['trackCount'] ?? 0,
      playCount: json['playCount'] ?? 0,
      subscribedCount: json['subscribedCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      creatorId: creator['userId'] ?? 0,
      creatorName: creator['nickname'] ?? '',
      creatorAvatar: creator['avatarUrl'] ?? '',
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      createTime: json['createTime'] ?? 0,
    );
  }
}
