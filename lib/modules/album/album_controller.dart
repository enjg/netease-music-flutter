import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/models/song_model.dart';
import '../../data/providers/album_provider.dart';

class AlbumController extends GetxController {
  final _client = ApiClient();
  final _provider = AlbumProvider();

  // 专辑数据
  final album = Rx<Map<String, dynamic>>({});
  final songs = <SongModel>[].obs;
  final dynamicInfo = Rx<Map<String, dynamic>>({});
  final comments = <Map<String, dynamic>>[].obs;
  final similar = <Map<String, dynamic>>[].obs;
  final privilege = Rx<Map<String, dynamic>>({});

  // 加载状态
  final isLoading = true.obs;
  final isLoadingComments = false.obs;

  int? get id => Get.arguments?['id'];

  @override
  void onInit() {
    super.onInit();
    if (id != null) loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final r = await _client.get('/album', queryParameters: {'id': id});
      album.value = Map.from(r.data['album'] ?? {});
      songs.assignAll((r.data['songs'] ?? []).map((s) => SongModel.fromJson(s)));
      await Future.wait([
        loadDynamic(),
        loadComments(),
        loadSimilar(),
        loadPrivilege(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 专辑动态信息
  Future<void> loadDynamic() async {
    try {
      final data = await _provider.getAlbumDynamic(id: id!);
      dynamicInfo.value = Map.from(data);
    } catch (_) {}
  }

  /// 热门评论
  Future<void> loadComments() async {
    try {
      final r = await _client.get('/comment/hot', queryParameters: {'id': id, 'type': 3, 'limit': 5});
      comments.assignAll((r.data['hotComments'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 相似专辑
  Future<void> loadSimilar() async {
    try {
      final r = await _client.get('/simi/album', queryParameters: {'id': id});
      similar.assignAll((r.data['albums'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  /// 专辑音质信息
  Future<void> loadPrivilege() async {
    try {
      final data = await _provider.getAlbumPrivilege(id: id!);
      privilege.value = Map.from(data);
    } catch (_) {}
  }

  /// 收藏/取消收藏专辑
  Future<void> toggleSubscribe() async {
    try {
      final isSubscribed = dynamicInfo.value['isSub'] ?? false;
      await _provider.subscribeAlbum(
        t: isSubscribed ? 2 : 1,
        id: id!,
      );
      // 更新动态信息
      await loadDynamic();
    } catch (_) {}
  }

  /// 加载更多评论
  Future<void> loadMoreComments() async {
    if (isLoadingComments.value) return;
    isLoadingComments.value = true;
    try {
      final data = await _provider.getAlbumComments(
        id: id!,
        limit: 20,
        offset: comments.length,
      );
      final moreComments = (data['comments'] ?? []).cast<Map<String, dynamic>>();
      comments.addAll(moreComments);
    } catch (_) {}
    isLoadingComments.value = false;
  }
}
