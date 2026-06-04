import 'package:get_storage/get_storage.dart';
import '../../config/constants.dart';

/// 本地存储封装
class LocalStorage {
  static LocalStorage? _instance;
  late final GetStorage _box;

  LocalStorage._();

  static Future<LocalStorage> init() async {
    if (_instance != null) return _instance!;
    _instance = LocalStorage._();
    await GetStorage.init();
    _instance!._box = GetStorage();
    return _instance!;
  }

  factory LocalStorage() => _instance!;

  // Token
  String? get token => _box.read<String>(AppConstants.keyToken);
  set token(String? value) => _box.write(AppConstants.keyToken, value);

  // UserId
  int? get userId => _box.read<int>(AppConstants.keyUserId);
  set userId(int? value) => _box.write(AppConstants.keyUserId, value);

  // 通用读写
  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write(String key, dynamic value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
  Future<void> clear() => _box.erase();

  // 搜索历史
  List<String> get searchHistory =>
      (_box.read<List>(AppConstants.keySearchHistory) ?? []).cast<String>();

  Future<void> addSearchHistory(String keyword) async {
    final history = searchHistory;
    history.remove(keyword);
    history.insert(0, keyword);
    if (history.length > 20) history.removeLast();
    await _box.write(AppConstants.keySearchHistory, history);
  }

  Future<void> clearSearchHistory() =>
      _box.remove(AppConstants.keySearchHistory);
}
