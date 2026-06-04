import '../../core/network/api_client.dart';

/// 云贝相关 API Provider
/// 涵盖：云贝信息、任务、推歌、收支记录等
class YunbeiProvider {
  final _client = ApiClient();

  /// 云贝信息
  Future<Map<String, dynamic>> getInfo() async {
    final r = await _client.get('/yunbei/info');
    return r.data;
  }

  /// 今日云贝
  Future<Map<String, dynamic>> getToday() async {
    final r = await _client.get('/yunbei/today');
    return r.data;
  }

  /// 云贝签到
  Future<Map<String, dynamic>> sign() async {
    final r = await _client.get('/yunbei/sign');
    return r.data;
  }

  /// 云贝任务列表
  Future<Map<String, dynamic>> getTasks() async {
    final r = await _client.get('/yunbei/tasks');
    return r.data;
  }

  /// 云贝待完成任务
  Future<Map<String, dynamic>> getTodoTasks() async {
    final r = await _client.get('/yunbei/tasks/todo');
    return r.data;
  }

  /// 完成云贝任务
  Future<Map<String, dynamic>> finishTask({
    required int userTaskId,
    String? depositCode,
  }) async {
    final r = await _client.get('/yunbei/task/finish', queryParameters: {
      'userTaskId': userTaskId,
      if (depositCode != null) 'depositCode': depositCode,
    });
    return r.data;
  }

  /// 云贝收入记录
  Future<Map<String, dynamic>> getReceipt({
    int limit = 20,
    int offset = 0,
  }) async {
    final r = await _client.get('/yunbei/receipt', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 云贝支出记录
  Future<Map<String, dynamic>> getExpense({
    int limit = 20,
    int offset = 0,
  }) async {
    final r = await _client.get('/yunbei/expense', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return r.data;
  }

  /// 云贝推歌
  Future<Map<String, dynamic>> recommendSong({
    required int id,
    required String reason,
    int yunbeiNum = 1,
  }) async {
    final r = await _client.get('/yunbei/rcmd/song', queryParameters: {
      'id': id,
      'reason': reason,
      'yunbeiNum': yunbeiNum,
    });
    return r.data;
  }

  /// 云贝推歌历史记录
  Future<Map<String, dynamic>> getRecommendHistory({
    int size = 20,
    String? cursor,
  }) async {
    final r = await _client.get('/yunbei/rcmd/song/history', queryParameters: {
      'size': size,
      if (cursor != null) 'cursor': cursor,
    });
    return r.data;
  }

  /// 云贝总览
  Future<Map<String, dynamic>> getYunbei() async {
    final r = await _client.get('/yunbei');
    return r.data;
  }
}
