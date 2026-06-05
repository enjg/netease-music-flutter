import 'package:get/get.dart';
import '../../core/network/api_client.dart';

class RadioController extends GetxController {
  final _client = ApiClient();
  final categories = <Map<String, dynamic>>[].obs;
  final radios = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final selectedCat = '全部'.obs;

  @override
  void onInit() { super.onInit(); loadData(); }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([loadCategories(), loadRadios()]);
    } finally { isLoading.value = false; }
  }

  Future<void> loadCategories() async {
    try {
      final r = await _client.get('/dj/category/list');
      categories.assignAll((r.data['categories'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  Future<void> loadRadios({int? typeId}) async {
    try {
      final r = await _client.get('/dj/recommend', queryParameters: {
        if (typeId != null) 'type': typeId,
      });
      radios.assignAll((r.data['djRadios'] ?? []).cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  void changeCategory(String cat, {int? typeId}) {
    selectedCat.value = cat;
    loadRadios(typeId: typeId);
  }

  Future<void> refresh() async => loadData();
}
