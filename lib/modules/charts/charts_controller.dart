import 'package:get/get.dart';
import '../../data/providers/charts_provider.dart';

class ChartsController extends GetxController {
  final _provider = ChartsProvider();

  // 榜单数据
  final officialCharts = <Map<String, dynamic>>[].obs;
  final globalCharts = <Map<String, dynamic>>[].obs;
  final topSongs = <Map<String, dynamic>>[].obs;
  final topArtists = <Map<String, dynamic>>[].obs;
  final topAlbums = <Map<String, dynamic>>[].obs;
  final topMvs = <Map<String, dynamic>>[].obs;
  final sheetList = <Map<String, dynamic>>[].obs;

  // 当前选中的榜单详情
  final currentChartDetail = Rx<Map<String, dynamic>>({});
  final currentChartSongs = <Map<String, dynamic>>[].obs;

  // 筛选条件
  final songType = 0.obs; // 0全部 7华语 96欧美 8日本 16韩国
  final albumArea = 0.obs; // 0全部 7华语 96欧美 8日本 16韩国
  final mvArea = '内地'.obs;

  final isLoading = true.obs;
  final isLoadingDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadToplist(),
        loadTopSongs(),
        loadTopArtists(),
        loadTopAlbums(),
        loadTopMv(),
        loadSheetList(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载所有榜单
  Future<void> loadToplist() async {
    try {
      final data = await _provider.getToplist();
      final list = (data['list'] ?? []).cast<Map<String, dynamic>>();
      officialCharts.assignAll(list.where((c) => (c['specialType'] ?? 0) != 0).take(5));
      globalCharts.assignAll(list.where((c) => (c['specialType'] ?? 0) == 0).take(10));
    } catch (_) {}
  }

  /// 加载新歌速递
  Future<void> loadTopSongs() async {
    try {
      final data = await _provider.getTopSongs(type: songType.value);
      topSongs.assignAll((data['data'] ?? []).cast<Map<String, dynamic>>().take(20));
    } catch (_) {}
  }

  /// 加载热门歌手
  Future<void> loadTopArtists() async {
    try {
      final data = await _provider.getTopArtists(limit: 20);
      topArtists.assignAll((data['artists'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 加载新碟上架
  Future<void> loadTopAlbums() async {
    try {
      final data = await _provider.getTopAlbum(
        area: albumArea.value == 0 ? null : albumArea.value,
        limit: 20,
      );
      topAlbums.assignAll((data['albums'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 加载 MV 排行榜
  Future<void> loadTopMv() async {
    try {
      final data = await _provider.getTopMv(area: mvArea.value, limit: 20);
      topMvs.assignAll((data['data'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 加载乐谱列表
  Future<void> loadSheetList() async {
    try {
      final data = await _provider.getSheetList(limit: 10);
      sheetList.assignAll((data['data']?['list'] ?? []).cast<Map<String, dynamic>>().take(10));
    } catch (_) {}
  }

  /// 加载榜单详情
  Future<void> loadChartDetail(int idx) async {
    isLoadingDetail.value = true;
    try {
      final data = await _provider.getTopList(idx: idx);
      currentChartDetail.value = data['playlist'] ?? {};
      currentChartSongs.assignAll(
        (data['playlist']?['tracks'] ?? []).cast<Map<String, dynamic>(),
      );
    } catch (_) {}
    isLoadingDetail.value = false;
  }

  /// 切换新歌类型
  void changeSongType(int type) {
    songType.value = type;
    loadTopSongs();
  }

  /// 切换专辑地区
  void changeAlbumArea(int area) {
    albumArea.value = area;
    loadTopAlbums();
  }

  /// 切换 MV 地区
  void changeMvArea(String area) {
    mvArea.value = area;
    loadTopMv();
  }

  /// 刷新全部数据
  Future<void> refreshAll() async {
    await loadData();
  }
}
