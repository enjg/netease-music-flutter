import 'package:get/get.dart';
import '../../data/providers/mv_provider.dart';

class VideoController extends GetxController {
  final _provider = MvProvider();
  final detail = Rx<Map<String, dynamic>>({});
  final detailInfo = Rx<Map<String, dynamic>>({});
  final url = Rx<Map<String, dynamic>>({});
  final relatedVideos = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  String? get vid => Get.arguments?['vid'];

  @override
  void onInit() {
    super.onInit();
    if (vid != null) loadVideoDetail();
  }

  Future<void> loadVideoDetail() async {
    isLoading.value = true;
    try {
      await Future.wait([loadDetail(), loadDetailInfo(), loadUrl(), loadRelated()]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadDetail() async {
    try { final d = await _provider.getVideoDetail(id: vid!); detail.value = Map.from(d['data'] ?? {}); } catch (_) {}
  }

  Future<void> loadDetailInfo() async {
    try { detailInfo.value = Map.from(await _provider.getVideoDetailInfo(vid: vid!)); } catch (_) {}
  }

  Future<void> loadUrl() async {
    try { final d = await _provider.getVideoUrl(id: vid!); url.value = Map.from(d['data'] ?? {}); } catch (_) {}
  }

  Future<void> loadRelated() async {
    try { final d = await _provider.getRelatedVideos(id: vid!); relatedVideos.assignAll((d['data'] ?? []).cast<Map<String, dynamic>>()); } catch (_) {}
  }

  Future<void> toggleSubscribe() async {
    try {
      final isSub = detailInfo.value['isSub'] ?? false;
      await _provider.subscribeVideo(t: isSub ? 2 : 1, id: vid!);
      await loadDetailInfo();
    } catch (_) {}
  }
}
