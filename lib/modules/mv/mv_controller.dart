import 'package:get/get.dart';
import '../../data/providers/mv_provider.dart';

class MvController extends GetxController {
  final _provider = MvProvider();

  // MV 数据
  final detail = Rx<Map<String, dynamic>>({});
  final detailInfo = Rx<Map<String, dynamic>>({});
  final url = Rx<Map<String, dynamic>>({});
  final similarMvs = <Map<String, dynamic>>[].obs;
  final comments = <Map<String, dynamic>>[].obs;

  // 推荐/排行榜数据
  final personalizedMvs = <Map<String, dynamic>>[].obs;
  final topMvs = <Map<String, dynamic>>[].obs;
  final newMvs = <Map<String, dynamic>>[].obs;
  final allMvs = <Map<String, dynamic>>[].obs;

  // 加载状态
  final isLoading = true.obs;
  final isLoadingMore = false.obs;

  // 筛选条件
  final selectedArea = '内地'.obs;
  final selectedType = '全部'.obs;
  final selectedOrder = '上升最快'.obs;

  // 分页
  int _allOffset = 0;
  int _topOffset = 0;
  int _newOffset = 0;

  int? get mvid => Get.arguments?['mvid'];

  @override
  void onInit() {
    super.onInit();
    if (mvid != null) {
      loadMvDetail();
    } else {
      loadRecommendations();
    }
  }

  /// 加载 MV 详情
  Future<void> loadMvDetail() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadDetail(),
        loadDetailInfo(),
        loadUrl(),
        loadSimilar(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// MV 详情
  Future<void> loadDetail() async {
    try {
      final data = await _provider.getMvDetail(mvid: mvid!);
      detail.value = Map.from(data['data'] ?? {});
    } catch (_) {}
  }

  /// MV 点赞转发评论数
  Future<void> loadDetailInfo() async {
    try {
      final data = await _provider.getMvDetailInfo(mvid: mvid!);
      detailInfo.value = Map.from(data);
    } catch (_) {}
  }

  /// MV 播放链接
  Future<void> loadUrl({int quality = 1080}) async {
    try {
      final data = await _provider.getMvUrl(id: mvid!, r: quality);
      url.value = Map.from(data['data'] ?? {});
    } catch (_) {}
  }

  /// 相似 MV
  Future<void> loadSimilar() async {
    try {
      final data = await _provider.getSimilarMv(mvid: mvid!);
      similarMvs.assignAll((data['mvs'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 收藏/取消收藏 MV
  Future<void> toggleSubscribe() async {
    try {
      final isSubscribed = detailInfo.value['subed'] ?? false;
      await _provider.subscribeMv(t: isSubscribed ? 2 : 1, mvid: mvid!);
      await loadDetailInfo();
    } catch (_) {}
  }

  /// 加载推荐 MV
  Future<void> loadRecommendations() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadPersonalizedMv(),
        loadTopMv(),
        loadNewMv(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 推荐 MV
  Future<void> loadPersonalizedMv() async {
    try {
      final data = await _provider.getPersonalizedMv();
      personalizedMvs.assignAll((data['result'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// MV 排行榜
  Future<void> loadTopMv() async {
    try {
      final data = await _provider.getTopMv(area: selectedArea.value, limit: 30);
      topMvs.assignAll((data['data'] ?? []).cast<Map<String, dynamic>>());
      _topOffset = topMvs.length;
    } catch (_) {}
  }

  /// 最新 MV
  Future<void> loadNewMv() async {
    try {
      final data = await _provider.getNewMv(area: selectedArea.value, limit: 30);
      newMvs.assignAll((data['data'] ?? []).cast<Map<String, dynamic>>());
      _newOffset = newMvs.length;
    } catch (_) {}
  }

  /// 全部 MV
  Future<void> loadAllMv() async {
    try {
      final data = await _provider.getAllMv(
        area: selectedArea.value,
        type: selectedType.value,
        order: selectedOrder.value,
        limit: 30,
      );
      allMvs.assignAll((data['data'] ?? []).cast<Map<String, dynamic>>());
      _allOffset = allMvs.length;
    } catch (_) {}
  }

  /// 加载更多全部 MV
  Future<void> loadMoreAllMv() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getAllMv(
        area: selectedArea.value,
        type: selectedType.value,
        order: selectedOrder.value,
        offset: _allOffset,
        limit: 30,
      );
      final more = (data['data'] ?? []).cast<Map<String, dynamic>>();
      allMvs.addAll(more);
      _allOffset = allMvs.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 切换地区
  void changeArea(String area) {
    selectedArea.value = area;
    loadTopMv();
    loadNewMv();
  }

  /// 切换类型
  void changeType(String type) {
    selectedType.value = type;
    loadAllMv();
  }

  /// 切换排序
  void changeOrder(String order) {
    selectedOrder.value = order;
    loadAllMv();
  }

  /// 刷新
  Future<void> refresh() async {
    if (mvid != null) {
      await loadMvDetail();
    } else {
      await loadRecommendations();
    }
  }
}
