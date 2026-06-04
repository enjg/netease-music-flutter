import 'package:get/get.dart';
import '../../data/providers/dj_provider.dart';

class DjController extends GetxController {
  final _provider = DjProvider();

  // 分类数据
  final categories = <Map<String, dynamic>>[].obs;
  final recommendCategories = <Map<String, dynamic>>[].obs;

  // 推荐数据
  final recommendDjs = <Map<String, dynamic>>[].obs;
  final personalizeDjs = <Map<String, dynamic>>[].obs;
  final hotDjs = <Map<String, dynamic>>[].obs;

  // 排行榜数据
  final toplist = <Map<String, dynamic>>[].obs;
  final programToplist = <Map<String, dynamic>>[].obs;

  // 电台详情
  final detail = Rx<Map<String, dynamic>>({});
  final programs = <Map<String, dynamic>>[].obs;

  // 加载状态
  final isLoading = true.obs;
  final isLoadingMore = false.obs;

  // 分页
  int _hotOffset = 0;
  int _programOffset = 0;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  /// 加载首页数据
  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadCategories(),
        loadRecommendDj(),
        loadPersonalizeDj(),
        loadHotDj(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载分类
  Future<void> loadCategories() async {
    try {
      final data = await _provider.getDjCategories();
      categories.assignAll((data['categories'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 推荐电台
  Future<void> loadRecommendDj() async {
    try {
      final data = await _provider.getDjRecommend();
      recommendDjs.assignAll((data['djRadios'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 电台个性推荐
  Future<void> loadPersonalizeDj() async {
    try {
      final data = await _provider.getDjPersonalize(limit: 6);
      personalizeDjs.assignAll((data['data'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 热门电台
  Future<void> loadHotDj() async {
    try {
      final data = await _provider.getDjHot(limit: 30);
      hotDjs.assignAll((data['djRadios'] ?? []).cast<Map<String, dynamic>>());
      _hotOffset = hotDjs.length;
    } catch (_) {}
  }

  /// 加载更多热门电台
  Future<void> loadMoreHotDj() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getDjHot(limit: 30, offset: _hotOffset);
      final more = (data['djRadios'] ?? []).cast<Map<String, dynamic>>();
      hotDjs.addAll(more);
      _hotOffset = hotDjs.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 加载电台详情
  Future<void> loadDjDetail(int id) async {
    isLoading.value = true;
    try {
      await Future.wait([_loadDetail(id), _loadPrograms(id)]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadDetail(int id) async {
    try {
      final data = await _provider.getDjDetail(id: id);
      detail.value = Map.from(data['data'] ?? {});
    } catch (_) {}
  }

  Future<void> _loadPrograms(int id) async {
    try {
      final data = await _provider.getDjPrograms(id: id, limit: 30);
      programs.assignAll((data['programs'] ?? []).cast<Map<String, dynamic>>());
      _programOffset = programs.length;
    } catch (_) {}
  }

  /// 加载更多节目
  Future<void> loadMorePrograms(int id) async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getDjPrograms(id: id, limit: 30, offset: _programOffset);
      final more = (data['programs'] ?? []).cast<Map<String, dynamic>>();
      programs.addAll(more);
      _programOffset = programs.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 订阅/取消订阅电台
  Future<void> toggleSubscribe(int id) async {
    try {
      final isSubscribed = detail.value['isSub'] ?? false;
      await _provider.subscribeDj(t: isSubscribed ? 2 : 1, rid: id);
      await _loadDetail(id);
    } catch (_) {}
  }

  /// 加载排行榜
  Future<void> loadToplist() async {
    try {
      await Future.wait([_loadToplist(), _loadProgramToplist()]);
    } catch (_) {}
  }

  Future<void> _loadToplist() async {
    try {
      final data = await _provider.getDjToplist(limit: 30);
      toplist.assignAll((data['toplist'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  Future<void> _loadProgramToplist() async {
    try {
      final data = await _provider.getDjProgramToplist(limit: 30);
      programToplist.assignAll((data['toplist'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 按分类加载电台
  Future<void> loadByCategory(int cateId) async {
    isLoading.value = true;
    try {
      final data = await _provider.getDjByCategory(cateId: cateId, limit: 30);
      hotDjs.assignAll((data['djRadios'] ?? []).cast<Map<String, dynamic>>());
    } finally {
      isLoading.value = false;
    }
  }

  /// 刷新
  Future<void> refresh() async {
    await loadHomeData();
  }
}
