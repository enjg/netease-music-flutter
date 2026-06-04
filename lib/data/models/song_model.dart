/// 歌曲数据模型
class SongModel {
  final int id;
  final String name;
  final List<String> artists;
  final List<int> artistIds;
  final String albumName;
  final String albumId;
  final String coverUrl;
  final int duration;  // 毫秒
  final int fee;       // 0=免费 1=VIP 4=付费 8=VIP
  final int? mvId;
  final String? lyrics;

  const SongModel({
    required this.id,
    required this.name,
    required this.artists,
    required this.artistIds,
    required this.albumName,
    required this.albumId,
    required this.coverUrl,
    required this.duration,
    required this.fee,
    this.mvId,
    this.lyrics,
  });

  String get artistText => artists.join(' / ');
  bool get isVip => fee == 1 || fee == 4 || fee == 8;
  int get durationSec => duration ~/ 1000;

  factory SongModel.fromJson(Map<String, dynamic> json) {
    final ar = json['ar'] as List? ?? json['artists'] as List? ?? [];
    final al = json['al'] as Map<String, dynamic>? ??
               json['album'] as Map<String, dynamic>? ?? {};

    return SongModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      artists: ar.map((a) => a['name']?.toString() ?? '').toList(),
      artistIds: ar.map((a) => a['id'] as int? ?? 0).toList(),
      albumName: al['name']?.toString() ?? '',
      albumId: al['id']?.toString() ?? '',
      coverUrl: al['picUrl']?.toString() ?? '',
      duration: json['dt'] ?? json['duration'] ?? 0,
      fee: json['fee'] ?? 0,
      mvId: json['mv'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'ar': artists.map((a) => {'name': a}).toList(),
    'al': {'name': albumName, 'id': albumId, 'picUrl': coverUrl},
    'dt': duration, 'fee': fee, 'mv': mvId,
  };
}
