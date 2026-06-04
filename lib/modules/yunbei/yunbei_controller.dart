import 'package:get/get.dart';
import '../../data/providers/yunbei_provider.dart';

class YunbeiController extends GetxController {
  final _provider = YunbeiProvider();

  // 云贝数据
  final balance = 0.obs;
  final info = Rx<Map<String, dynamic>>({});
  final todayInfo = Rx<Map<String, dynamic>>({});
  final records = <Map<String, dynamic>>[].obs;
  final tasks = <Map<String, dynamic>>[].obs;
  final todoTasks = <Map<String, dynamic>>[].obs;

  // 收支记录
  final receipts = <Map<String, dynamic>>[].obs;
  final expenses = <Map<String, dynamic>>[].obs;

  // 推歌历史
  final rcmdHistory = <Map<String, dynamic>>[].obs;

  // 加载状态
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final isSigning = false.obs;

  // 分页
  int _receiptOffset = 0;
  int _expenseOffset = 0;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadInfo(),
        loadBalance(),
        loadTasks(),
        loadTodoTasks(),
        loadToday(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 云贝信息
  Future<void> loadInfo() async {
    try {
      final data = await _provider.getInfo();
      info.value = Map.from(data['data'] ?? {});
    } catch (_) {}
  }

  /// 今日云贝
  Future<void> loadBalance() async {
    try {
      final data = await _provider.getToday();
      balance.value = data['data']?['yunbei'] ?? 0;
      todayInfo.value = Map.from(data['data'] ?? {});
    } catch (_) {}
  }

  /// 任务列表
  Future<void> loadTasks() async {
    try {
      final data = await _provider.getTasks();
      tasks.assignAll((data['data'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 待完成任务
  Future<void> loadTodoTasks() async {
    try {
      final data = await _provider.getTodoTasks();
      todoTasks.assignAll((data['data'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 今日云贝详情
  Future<void> loadToday() async {
    try {
      final data = await _provider.getToday();
      todayInfo.value = Map.from(data['data'] ?? {});
    } catch (_) {}
  }

  /// 签到
  Future<bool> doSign() async {
    isSigning.value = true;
    try {
      await _provider.sign();
      await Future.wait([loadInfo(), loadBalance()]);
      return true;
    } catch (_) {
      return false;
    } finally {
      isSigning.value = false;
    }
  }

  /// 完成任务
  Future<bool> finishTask(int userTaskId, {String? depositCode}) async {
    try {
      await _provider.finishTask(userTaskId: userTaskId, depositCode: depositCode);
      await Future.wait([loadTasks(), loadTodoTasks(), loadBalance()]);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 加载收入记录
  Future<void> loadReceipts() async {
    try {
      final data = await _provider.getReceipt(limit: 30);
      receipts.assignAll((data['data']?['list'] ?? []).cast<Map<String, dynamic>>());
      _receiptOffset = receipts.length;
    } catch (_) {}
  }

  /// 加载更多收入记录
  Future<void> loadMoreReceipts() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getReceipt(limit: 30, offset: _receiptOffset);
      final more = (data['data']?['list'] ?? []).cast<Map<String, dynamic>>();
      receipts.addAll(more);
      _receiptOffset = receipts.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 加载支出记录
  Future<void> loadExpenses() async {
    try {
      final data = await _provider.getExpense(limit: 30);
      expenses.assignAll((data['data']?['list'] ?? []).cast<Map<String, dynamic>>());
      _expenseOffset = expenses.length;
    } catch (_) {}
  }

  /// 加载更多支出记录
  Future<void> loadMoreExpenses() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getExpense(limit: 30, offset: _expenseOffset);
      final more = (data['data']?['list'] ?? []).cast<Map<String, dynamic>>();
      expenses.addAll(more);
      _expenseOffset = expenses.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 推歌
  Future<bool> recommendSong(int id, String reason, {int yunbeiNum = 1}) async {
    try {
      await _provider.recommendSong(id: id, reason: reason, yunbeiNum: yunbeiNum);
      await loadBalance();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 加载推歌历史
  Future<void> loadRcmdHistory() async {
    try {
      final data = await _provider.getRecommendHistory(size: 30);
      rcmdHistory.assignAll((data['data']?['list'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 刷新
  Future<void> refresh() async {
    await loadData();
  }
}
