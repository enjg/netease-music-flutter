/// 歌手数据模型
class ArtistModel {
  final int id;
  final String name;
  final String avatar;
  final String cover;
  final List<String> alias;
  final int musicSize;
  final int albumSize;
  final int mvSize;
  final int fansCount;
  final String description;
  final List<String> identities;

  const ArtistModel({
    required this.id,
    required this.name,
    this.avatar = '',
    this.cover = '',
    this.alias = const [],
    this.musicSize = 0,
    this.albumSize = 0,
    this.mvSize = 0,
    this.fansCount = 0,
    this.description = '',
    this.identities = const [],
  });

  String get displayName => alias.isNotEmpty ? '$name (${alias.first})' : name;

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? json['picUrl'] ?? json['img1v1Url'] ?? '',
      cover: json['cover'] ?? json['picUrl'] ?? '',
      alias: (json['alias'] as List?)?.cast<String>() ?? [],
      musicSize: json['musicSize'] ?? 0,
      albumSize: json['albumSize'] ?? 0,
      mvSize: json['mvSize'] ?? 0,
      fansCount: json['fansCount'] ?? 0,
      description: json['briefDesc'] ?? json['description'] ?? '',
      identities: (json['identities'] as List?)?.cast<String>() ?? [],
    );
  }
}
