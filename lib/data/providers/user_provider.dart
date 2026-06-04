import '../../core/network/api_client.dart';

/// 用户相关 API Provider
/// 涵盖：用户信息、关注、粉丝、听歌记录、云盘、状态等
class UserProvider {
  final _client = ApiClient();

  /// 用户账号信息
  Future<Map<String, dynamic>> getAccount() async {
    final r = await _client.get('/user/account');
    return r.data;
  }

  /// 用户详情
  Future<Map<String, dynamic>> getDetail({required int uid}) async {
    final r = await _client.get('/user/detail', queryParameters: {'uid': uid});
    return r.data;
  }

  /// 用户详情 (新版)
  Future<Map<String, dynamic>> getDetailNew({required int uid}) async {
    final r = await _client.get('/user/detail/new', queryParameters: {'uid': uid});
    return r.data;
  }

  /// 编辑用户信息
  Future<Map<String, dynamic>> updateProfile({
    String? nickname,
    int? gender,
    int? birthday,
    int? province,
    int? city,
    String? signature,
  }) async {
    final r = await _client.get('/user/update', queryParameters: {
      if (nickname != null) 'nickname': nickname,
      if (gender != null) 'gender': gender,
      if (birthday != null) 'birthday': birthday,
      if (province != null) 'province': province,
      if (city != null) 'city': city,
      if (signature != null) 'signature': signature,
    });
    return r.data;
  }

  /// 用户等级
  Future<Map<String, dynamic>> getLevel() async {
    final r = await _client.get('/user/level');
    return r.data;
  }

  /// 收藏计数
  Future<Map<String, dynamic>> getSubcount() async {
    final r = await _client.get('/user/subcount');
    return r.data;
  }

  /// 用户徽章
  Future<Map<String, dynamic>> getMedal({required int uid}) async {
    final r = await _client.get('/user/medal', queryParameters: {'uid': uid});
    return r.data;
  }

  /// 用户绑定信息
  Future<Map<String, dynamic>> getBinding({required int uid}) async {
    final r = await _client.get('/user/binding', queryParameters: {'uid': uid});
    return r.data;
  }

  // ========== 关注/粉丝 ==========

  /// 关注/取消关注用户
  /// t: 1 关注, 0 取消关注
  Future<Map<String, dynamic>> follow({required int t, required int id}) async {
    final r = await _client.get('/follow', queryParameters: {'t': t, 'id': id});
    return r.data;
  }

  /// TA 关注的人
  Future<Map<String, dynamic>> getFollows({
    required int uid,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/user/follows', queryParameters: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 关注 TA 的人 (粉丝)
  Future<Map<String, dynamic>> getFolloweds({
    required int uid,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/user/followeds', queryParameters: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 当前账号关注的用户/歌手
  Future<Map<String, dynamic>> getFollowMixed({
    int size = 30,
    String? cursor,
    int scene = 0,
  }) async {
    final r = await _client.get('/user/follow/mixed', queryParameters: {
      'size': size,
      if (cursor != null) 'cursor': cursor,
      'scene': scene,
    });
    return r.data;
  }

  /// 用户是否互相关注
  Future<Map<String, dynamic>> getMutualFollow({required int uid}) async {
    final r = await _client.get('/user/mutualfollow/get', queryParameters: {'uid': uid});
    return r.data;
  }

  /// 相似用户
  Future<Map<String, dynamic>> getSimilarUsers({
    required int id,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/simi/user', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  // ========== 听歌记录 ==========

  /// 听歌排行
  /// type: 1 最近一周, 0 所有时间
  Future<Map<String, dynamic>> getRecord({
    required int uid,
    int type = 1,
  }) async {
    final r = await _client.get('/user/record', queryParameters: {
      'uid': uid,
      'type': type,
    });
    return r.data;
  }

  /// 最近播放-歌曲
  Future<Map<String, dynamic>> getRecentSong({int limit = 50}) async {
    final r = await _client.get('/record/recent/song', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 最近播放-歌单
  Future<Map<String, dynamic>> getRecentPlaylist({int limit = 50}) async {
    final r = await _client.get('/record/recent/playlist', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 最近播放-专辑
  Future<Map<String, dynamic>> getRecentAlbum({int limit = 50}) async {
    final r = await _client.get('/record/recent/album', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 最近播放-电台
  Future<Map<String, dynamic>> getRecentDj({int limit = 50}) async {
    final r = await _client.get('/record/recent/dj', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 最近播放-视频
  Future<Map<String, dynamic>> getRecentVideo({int limit = 50}) async {
    final r = await _client.get('/record/recent/video', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 最近播放-播客
  Future<Map<String, dynamic>> getRecentVoice({int limit = 50}) async {
    final r = await _client.get('/record/recent/voice', queryParameters: {'limit': limit});
    return r.data;
  }

  // ========== 歌单 ==========

  /// 用户歌单
  Future<Map<String, dynamic>> getPlaylists({
    required int uid,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/user/playlist', queryParameters: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 用户创建的歌单
  Future<Map<String, dynamic>> getCreatedPlaylists({
    required int uid,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/user/playlist/create', queryParameters: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 用户收藏的歌单
  Future<Map<String, dynamic>> getCollectedPlaylists({
    required int uid,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/user/playlist/collect', queryParameters: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  // ========== 云盘 ==========

  /// 云盘数据
  Future<Map<String, dynamic>> getCloud({
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _client.get('/user/cloud', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 云盘数据详情
  Future<Map<String, dynamic>> getCloudDetail({required int id}) async {
    final r = await _client.get('/user/cloud/detail', queryParameters: {'id': id});
    return r.data;
  }

  /// 云盘歌曲删除
  Future<Map<String, dynamic>> deleteCloudSong({required int id}) async {
    final r = await _client.get('/user/cloud/del', queryParameters: {'id': id});
    return r.data;
  }

  // ========== 动态/状态 ==========

  /// 用户动态
  Future<Map<String, dynamic>> getEvents({
    required int uid,
    int limit = 30,
    int? lasttime,
  }) async {
    final r = await _client.get('/user/event', queryParameters: {
      'uid': uid,
      'limit': limit,
      if (lasttime != null) 'lasttime': lasttime,
    });
    return r.data;
  }

  /// 用户创建的电台
  Future<Map<String, dynamic>> getDj({required int uid}) async {
    final r = await _client.get('/user/audio', queryParameters: {'uid': uid});
    return r.data;
  }

  /// 用户状态
  Future<Map<String, dynamic>> getSocialStatus({required int uid}) async {
    final r = await _client.get('/user/social/status', queryParameters: {'uid': uid});
    return r.data;
  }

  /// 用户状态 - 支持设置的状态
  Future<Map<String, dynamic>> getSocialStatusSupport() async {
    final r = await _client.get('/user/social/status/support');
    return r.data;
  }

  /// 用户状态 - 编辑
  Future<Map<String, dynamic>> editSocialStatus({
    required int type,
    String? iconUrl,
    String? content,
    String? actionUrl,
  }) async {
    final r = await _client.get('/user/social/status/edit', queryParameters: {
      'type': type,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (content != null) 'content': content,
      if (actionUrl != null) 'actionUrl': actionUrl,
    });
    return r.data;
  }

  /// 用户状态 - 相同状态的用户
  Future<Map<String, dynamic>> getSocialStatusRcmd() async {
    final r = await _client.get('/user/social/status/rcmd');
    return r.data;
  }

  // ========== 粉丝数据 ==========

  /// 粉丝数量
  Future<Map<String, dynamic>> getFansOverview() async {
    final r = await _client.get('/fanscenter/overview/get');
    return r.data;
  }

  /// 粉丝年龄比例
  Future<Map<String, dynamic>> getFansAge() async {
    final r = await _client.get('/fanscenter/basicinfo/age/get');
    return r.data;
  }

  /// 粉丝性别比例
  Future<Map<String, dynamic>> getFansGender() async {
    final r = await _client.get('/fanscenter/basicinfo/gender/get');
    return r.data;
  }

  /// 粉丝省份比例
  Future<Map<String, dynamic>> getFansProvince() async {
    final r = await _client.get('/fanscenter/basicinfo/province/get');
    return r.data;
  }

  /// 粉丝来源
  Future<Map<String, dynamic>> getFansTrend({
    required int startTime,
    required int endTime,
    int type = 0,
  }) async {
    final r = await _client.get('/fanscenter/trend/list', queryParameters: {
      'startTime': startTime,
      'endTime': endTime,
      'type': type,
    });
    return r.data;
  }

  // ========== 其他 ==========

  /// 用户贡献条目、积分、云贝数量
  Future<Map<String, dynamic>> getUgcDevote() async {
    final r = await _client.get('/ugc/user/devote');
    return r.data;
  }

  /// 歌词摘录 - 我的歌词本
  Future<Map<String, dynamic>> getLyricsMark({
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/song/lyrics/mark/user/page', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 获取用户ID
  Future<Map<String, dynamic>> getUserIds({required String nicknames}) async {
    final r = await _client.get('/get/userids', queryParameters: {'nicknames': nicknames});
    return r.data;
  }

  /// 绑定手机号
  Future<Map<String, dynamic>> bindPhone({
    required String phone,
    required String captcha,
    String? countrycode,
    String? password,
  }) async {
    final r = await _client.get('/user/bindingcellphone', queryParameters: {
      'phone': phone,
      'captcha': captcha,
      if (countrycode != null) 'countrycode': countrycode,
      if (password != null) 'password': password,
    });
    return r.data;
  }

  /// 更换手机号
  Future<Map<String, dynamic>> replacePhone({
    required String phone,
    required String captcha,
    required String oldcaptcha,
    String? countrycode,
  }) async {
    final r = await _client.get('/user/replacephone', queryParameters: {
      'phone': phone,
      'captcha': captcha,
      'oldcaptcha': oldcaptcha,
      if (countrycode != null) 'countrycode': countrycode,
    });
    return r.data;
  }

  /// 匿名注册
  Future<Map<String, dynamic>> registerAnonymous() async {
    final r = await _client.get('/register/anonimous');
    return r.data;
  }

  /// 手机号登录
  Future<Map<String, dynamic>> loginByPhone(String phone, String captcha) async {
    final r = await _client.get('/login/cellphone', queryParameters: {
      'phone': phone,
      'captcha': captcha,
    });
    return r.data;
  }

  /// 退出登录
  Future<Map<String, dynamic>> logout() async {
    final r = await _client.get('/logout');
    return r.data;
  }
}
