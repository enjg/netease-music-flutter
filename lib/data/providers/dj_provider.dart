import '../../core/network/api_client.dart';

/// 电台相关 API Provider
/// 涵盖：电台详情、节目、分类、排行榜、订阅等
class DjProvider {
  final _client = ApiClient();

  /// 电台分类列表
  Future<Map<String, dynamic>> getDjCategories() async {
    final r = await _client.get('/dj/catelist');
    return r.data;
  }

  /// 电台非热门类型
  Future<Map<String, dynamic>> getDjCategoryExcludeHot() async {
    final r = await _client.get('/dj/category/excludehot');
    return r.data;
  }

  /// 电台推荐类型
  Future<Map<String, dynamic>> getDjCategoryRecommend() async {
    final r = await _client.get('/dj/category/recommend');
    return r.data;
  }

  /// 电台 banner
  Future<Map<String, dynamic>> getDjBanner() async {
    final r = await _client.get('/dj/banner');
    return r.data;
  }

  /// 精选电台
  Future<Map<String, dynamic>> getDjRecommend() async {
    final r = await _client.get('/dj/recommend');
    return r.data;
  }

  /// 精选电台分类
  Future<Map<String, dynamic>> getDjRecommendByType({required int type}) async {
    final r = await _client.get('/dj/recommend/type', queryParameters: {'type': type});
    return r.data;
  }

  /// 电台个性推荐
  Future<Map<String, dynamic>> getDjPersonalize({int limit = 6}) async {
    final r = await _client.get('/dj/personalize/recommend', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 推荐电台
  Future<Map<String, dynamic>> getPersonalizedDj() async {
    final r = await _client.get('/personalized/djprogram');
    return r.data;
  }

  /// 热门电台
  Future<Map<String, dynamic>> getDjHot({
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/dj/hot', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 类别热门电台
  Future<Map<String, dynamic>> getDjByCategory({
    required int cateId,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/dj/radio/hot', queryParameters: {
      'cateId': cateId,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 电台详情
  Future<Map<String, dynamic>> getDjDetail({required int id}) async {
    final r = await _client.get('/dj/detail', queryParameters: {'id': id});
    return r.data;
  }

  /// 电台节目列表
  Future<Map<String, dynamic>> getDjPrograms({
    required int id,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/dj/program', queryParameters: {
      'id': id,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 电台节目详情
  Future<Map<String, dynamic>> getDjProgramDetail({required int id}) async {
    final r = await _client.get('/dj/program/detail', queryParameters: {'id': id});
    return r.data;
  }

  /// 订阅/取消订阅电台
  /// t: 1 订阅, 2 取消订阅
  Future<Map<String, dynamic>> subscribeDj({
    required int t,
    required int rid,
  }) async {
    final r = await _client.get('/dj/sub', queryParameters: {'t': t, 'rid': rid});
    return r.data;
  }

  /// 订阅电台列表
  Future<Map<String, dynamic>> getDjSublist({
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/dj/sublist', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 电台订阅者
  Future<Map<String, dynamic>> getDjSubscribers({
    required int id,
    int limit = 30,
    int? time,
  }) async {
    final r = await _client.get('/dj/subscriber', queryParameters: {
      'id': id,
      'limit': limit,
      if (time != null) 'time': time,
    });
    return r.data;
  }

  /// 付费电台
  Future<Map<String, dynamic>> getDjPaygift({
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/dj/paygift', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 电台今日优选
  Future<Map<String, dynamic>> getDjToday({int page = 1}) async {
    final r = await _client.get('/dj/today/perfered', queryParameters: {'page': page});
    return r.data;
  }

  /// 新晋电台榜/热门电台榜
  /// type: new 新晋, hot 热门
  Future<Map<String, dynamic>> getDjToplist({
    String type = 'new',
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/dj/toplist', queryParameters: {
      'type': type,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 电台节目榜
  Future<Map<String, dynamic>> getDjProgramToplist({
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/dj/program/toplist', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 电台24小时节目榜
  Future<Map<String, dynamic>> getDjProgramToplistHours({int limit = 30}) async {
    final r = await _client.get('/dj/program/toplist/hours', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 电台24小时主播榜
  Future<Map<String, dynamic>> getDjToplistHours({int limit = 30}) async {
    final r = await _client.get('/dj/toplist/hours', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 电台新人榜
  Future<Map<String, dynamic>> getDjNewcomer({
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/dj/toplist/newcomer', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 付费精品
  Future<Map<String, dynamic>> getDjToplistPay({int limit = 30}) async {
    final r = await _client.get('/dj/toplist/pay', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 电台最热主播榜
  Future<Map<String, dynamic>> getDjToplistPopular({int limit = 30}) async {
    final r = await _client.get('/dj/toplist/popular', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 电台排行榜获取
  Future<Map<String, dynamic>> getDjRadioTop({
    required int djRadioId,
    int sortIndex = 1,
    int dataGapDays = 7,
    int dataType = 1,
  }) async {
    final r = await _client.get('/djRadio/top', queryParameters: {
      'djRadioId': djRadioId,
      'sortIndex': sortIndex,
      'dataGapDays': dataGapDays,
      'dataType': dataType,
    });
    return r.data;
  }

  /// 推荐节目
  Future<Map<String, dynamic>> getProgramRecommend({
    int type = 0,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/program/recommend', queryParameters: {
      'type': type,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 用户电台节目
  Future<Map<String, dynamic>> getUserDj({
    required int uid,
    int limit = 30,
    int offset = 0,
  }) async {
    final r = await _client.get('/user/dj', queryParameters: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 最近播放电台
  Future<Map<String, dynamic>> getRecentDj({int limit = 30}) async {
    final r = await _client.get('/record/recent/dj', queryParameters: {'limit': limit});
    return r.data;
  }

  /// 私人 DJ
  Future<Map<String, dynamic>> getAidjContent({
    double? latitude,
    double? longitude,
  }) async {
    final r = await _client.get('/aidj/content/rcmd', queryParameters: {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
    return r.data;
  }

  /// 跑步漫游
  Future<Map<String, dynamic>> getRadioSport({int? bpm}) async {
    final r = await _client.get('/radio/sport/get', queryParameters: {
      if (bpm != null) 'bpm': bpm,
    });
    return r.data;
  }

  /// DIFM电台 - 分类
  Future<Map<String, dynamic>> getDifmStyles({String? sources}) async {
    final r = await _client.get('/dj/difm/all/style/channel', queryParameters: {
      if (sources != null) 'sources': sources,
    });
    return r.data;
  }

  /// DIFM电台 - 播放列表
  Future<Map<String, dynamic>> getDifmTracks({
    required String channelId,
    String? source,
    int limit = 30,
  }) async {
    final r = await _client.get('/dj/difm/playing/tracks/list', queryParameters: {
      'channelId': channelId,
      if (source != null) 'source': source,
      'limit': limit,
    });
    return r.data;
  }

  /// DIFM电台 - 收藏频道
  Future<Map<String, dynamic>> subscribeDifm({required String id}) async {
    final r = await _client.get('/dj/difm/channel/subscribe', queryParameters: {'id': id});
    return r.data;
  }

  /// DIFM电台 - 取消收藏频道
  Future<Map<String, dynamic>> unsubscribeDifm({required String id}) async {
    final r = await _client.get('/dj/difm/channel/unsubscribe', queryParameters: {'id': id});
    return r.data;
  }

  /// DIFM电台 - 收藏列表
  Future<Map<String, dynamic>> getDifmSubscriptions({String? sources}) async {
    final r = await _client.get('/dj/difm/subscribe/channels/get', queryParameters: {
      if (sources != null) 'sources': sources,
    });
    return r.data;
  }
}
