/// 用户数据模型
class UserModel {
  final int userId;
  final String nickname;
  final String avatarUrl;
  final String backgroundUrl;
  final String signature;
  final int gender;
  final int level;
  final int listenSongs;
  final int vipType;
  final int follows;
  final int followeds;
  final int playlistCount;
  final int playlistBeSubscribedCount;

  const UserModel({
    required this.userId,
    required this.nickname,
    this.avatarUrl = '',
    this.backgroundUrl = '',
    this.signature = '',
    this.gender = 0,
    this.level = 0,
    this.listenSongs = 0,
    this.vipType = 0,
    this.follows = 0,
    this.followeds = 0,
    this.playlistCount = 0,
    this.playlistBeSubscribedCount = 0,
  });

  bool get isVip => vipType > 0;
  bool get isLoggedIn => userId > 0;

  factory UserModel.fromAccountAndDetail(
    Map<String, dynamic> account,
    Map<String, dynamic> profile,
    Map<String, dynamic> detail,
  ) {
    return UserModel(
      userId: profile['userId'] ?? account['id'] ?? 0,
      nickname: profile['nickname'] ?? '',
      avatarUrl: profile['avatarUrl'] ?? '',
      backgroundUrl: profile['backgroundUrl'] ?? '',
      signature: profile['signature'] ?? '',
      gender: profile['gender'] ?? 0,
      level: detail['level'] ?? 0,
      listenSongs: detail['listenSongs'] ?? 0,
      vipType: profile['vipType'] ?? account['vipType'] ?? 0,
      follows: profile['follows'] ?? 0,
      followeds: profile['followeds'] ?? 0,
      playlistCount: profile['playlistCount'] ?? 0,
      playlistBeSubscribedCount: profile['playlistBeSubscribedCount'] ?? 0,
    );
  }

  factory UserModel.empty() => const UserModel(userId: 0, nickname: '');
}
