import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/models/song_model.dart';
import '../../data/providers/artist_provider.dart';

class ArtistController extends GetxController {
  final _client = ApiClient();
  final _provider = ArtistProvider();

  // 歌手数据
  final detail = Rx<Map<String, dynamic>>({});
  final dynamicInfo = Rx<Map<String, dynamic>>({});
  final desc = ''.obs;
  final songs = <SongModel>[].obs;
  final topSongs = <SongModel>[].obs;
  final albums = <Map<String, dynamic>>[].obs;
  final mvs = <Map<String, dynamic>>[].obs;
  final videos = <Map<String, dynamic>>[].obs;
  final similar = <Map<String, dynamic>>[].obs;
  final followCount = Rx<Map<String, dynamic>>({});

  // 加载状态
  final isLoading = true.obs;
  final isLoadingMore = false.obs;

  // 分页
  final _songOffset = 0.obs;
  final _albumOffset = 0.obs;
  final _mvOffset = 0.obs;

  int? get id => Get.arguments?['id'];

  @override
  void onInit() {
    super.onInit();
    if (id != null) loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadDetail(),
        loadDesc(),
        loadSongs(),
        loadTopSongs(),
        loadAlbums(),
        loadMvs(),
        loadSimilar(),
        loadFollowCount(),
        loadDynamic(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 歌手详情
  Future<void> loadDetail() async {
    try {
      final data = await _provider.getArtistDetail(id: id!);
      detail.value = Map.from(data['data']?['artist'] ?? {});
    } catch (_) {}
  }

  /// 歌手动态信息
  Future<void> loadDynamic() async {
    try {
      final data = await _provider.getArtistDynamic(id: id!);
      dynamicInfo.value = Map.from(data);
    } catch (_) {}
  }

  /// 歌手介绍
  Future<void> loadDesc() async {
    try {
      final data = await _provider.getArtistDesc(id: id!);
      desc.value = data['briefDesc'] ?? '';
    } catch (_) {}
  }

  /// 歌手歌曲列表
  Future<void> loadSongs() async {
    try {
      final data = await _provider.getArtistSongs(id: id!, limit: 50);
      songs.assignAll((data['songs'] ?? []).map((s) => SongModel.fromJson(s)));
      _songOffset.value = songs.length;
    } catch (_) {}
  }

  /// 歌手热门 50 首
  Future<void> loadTopSongs() async {
    try {
      final data = await _provider.getArtistTopSongs(id: id!);
      topSongs.assignAll((data['songs'] ?? []).map((s) => SongModel.fromJson(s)));
    } catch (_) {}
  }

  /// 歌手专辑列表
  Future<void> loadAlbums() async {
    try {
      final data = await _provider.getArtistAlbums(id: id!, limit: 20);
      albums.assignAll((data['hotAlbums'] ?? []).cast<Map<String, dynamic>>());
      _albumOffset.value = albums.length;
    } catch (_) {}
  }

  /// 歌手 MV
  Future<void> loadMvs() async {
    try {
      final data = await _provider.getArtistMvs(id: id!, limit: 20);
      mvs.assignAll((data['mvs'] ?? []).cast<Map<String, dynamic>>());
      _mvOffset.value = mvs.length;
    } catch (_) {}
  }

  /// 相似歌手
  Future<void> loadSimilar() async {
    try {
      final data = await _provider.getSimilarArtists(id: id!);
      similar.assignAll((data['artists'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 粉丝数量
  Future<void> loadFollowCount() async {
    try {
      final data = await _provider.getArtistFollowCount(id: id!);
      followCount.value = Map.from(data);
    } catch (_) {}
  }

  /// 收藏/取消收藏歌手
  Future<void> toggleSubscribe() async {
    try {
      final isSubscribed = dynamicInfo.value['followed'] ?? false;
      await _provider.subscribeArtist(t: isSubscribed ? 2 : 1, id: id!);
      await loadDynamic();
    } catch (_) {}
  }

  /// 加载更多歌曲
  Future<void> loadMoreSongs() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getArtistSongs(
        id: id!,
        limit: 50,
        offset: _songOffset.value,
      );
      final more = (data['songs'] ?? []).map((s) => SongModel.fromJson(s));
      songs.addAll(more);
      _songOffset.value = songs.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 加载更多专辑
  Future<void> loadMoreAlbums() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getArtistAlbums(
        id: id!,
        limit: 20,
        offset: _albumOffset.value,
      );
      final more = (data['hotAlbums'] ?? []).cast<Map<String, dynamic>>();
      albums.addAll(more);
      _albumOffset.value = albums.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }

  /// 加载更多 MV
  Future<void> loadMoreMvs() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final data = await _provider.getArtistMvs(
        id: id!,
        limit: 20,
        offset: _mvOffset.value,
      );
      final more = (data['mvs'] ?? []).cast<Map<String, dynamic>>();
      mvs.addAll(more);
      _mvOffset.value = mvs.length;
    } catch (_) {}
    isLoadingMore.value = false;
  }
}
