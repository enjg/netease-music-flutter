import 'artist_model.dart';

/// 专辑数据模型
class AlbumModel {
  final int id;
  final String name;
  final String coverUrl;
  final ArtistModel artist;
  final String description;
  final String company;
  final int publishTime;
  final int songCount;
  final int size;

  const AlbumModel({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.artist,
    this.description = '',
    this.company = '',
    this.publishTime = 0,
    this.songCount = 0,
    this.size = 0,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      coverUrl: json['picUrl'] ?? '',
      artist: ArtistModel.fromJson(json['artist'] ?? json['artists']?[0] ?? {}),
      description: json['description'] ?? '',
      company: json['company'] ?? '',
      publishTime: json['publishTime'] ?? 0,
      songCount: json['size'] ?? 0,
      size: json['size'] ?? 0,
    );
  }
}
