import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class LiveController extends GetxController {
  final _client = ApiClient();
  final channels = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final currentCat = 'all'.obs;

  @override void onInit() { super.onInit(); loadChannels(); }

  Future<void> loadChannels() async {
    isLoading.value = true;
    try {
      final r = await _client.get('/broadcast/channel/list', queryParameters: {'limit': 100});
      channels.assignAll((r.data['data']?['list'] ?? []).cast<Map<String, dynamic>>());
    } catch(_) {}
    finally { isLoading.value = false; }
  }

  void switchCat(String cat) { currentCat.value = cat; }
}
