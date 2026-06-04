import 'package:get/get.dart';
import '../../core/storage/local_storage.dart';
import '../../data/providers/user_provider.dart';
import '../../data/models/user_model.dart';

/// 全局认证服务 - 单例
class AuthService extends GetxService {
  final _userProvider = UserProvider();
  final _storage = LocalStorage();

  final isLoggedIn = false.obs;
  final isAnonymous = true.obs;
  final user = UserModel.empty().obs;
  final isLoading = false.obs;

  int? get userId => _storage.userId;
  String? get token => _storage.token;
  bool get isRealUser => isLoggedIn.value && !isAnonymous.value;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  /// 初始化认证：先尝试恢复登录，失败则匿名登录
  Future<void> _initAuth() async {
    final uid = _storage.userId;
    if (uid != null && uid > 0) {
      await _loadUser();
      if (isLoggedIn.value) return;
    }
    // 未登录或登录失效，自动匿名登录
    await loginAnonymous();
  }

  /// 加载已登录用户信息
  Future<void> _loadUser() async {
    final uid = _storage.userId;
    if (uid == null || uid == 0) return;

    try {
      isLoading.value = true;
      final accountData = await _userProvider.getAccount();
      if (accountData['code'] == 200 && accountData['account'] != null) {
        final profile = accountData['profile'] ?? {};
        final detailData = await _userProvider.getDetail(uid: uid);
        user.value = UserModel.fromAccountAndDetail(
          accountData['account'],
          profile,
          detailData,
        );
        isLoggedIn.value = true;
        isAnonymous.value = false;
      }
    } catch (e) {
      // 静默失败
    } finally {
      isLoading.value = false;
    }
  }

  /// 游客匿名登录
  Future<bool> loginAnonymous() async {
    try {
      isLoading.value = true;
      final data = await _userProvider.registerAnonymous();
      if (data['code'] == 200) {
        _storage.userId = data['account']?['id'];
        _storage.token = data['token'] ?? '';
        isLoggedIn.value = true;
        isAnonymous.value = true;
        // 尝试获取用户信息
        try {
          final accountData = await _userProvider.getAccount();
          if (accountData['account'] != null) {
            final profile = accountData['profile'] ?? {};
            final uid = data['account']?['id'] ?? 0;
            if (uid > 0) {
              final detailData = await _userProvider.getDetail(uid: uid);
              user.value = UserModel.fromAccountAndDetail(
                accountData['account'],
                profile,
                detailData,
              );
            }
          }
        } catch (_) {}
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 手机号登录
  Future<bool> loginByPhone(String phone, String captcha) async {
    try {
      isLoading.value = true;
      final data = await _userProvider.loginByPhone(phone, captcha);
      if (data['code'] == 200) {
        _storage.token = data['token'];
        _storage.userId = data['account']?['id'];
        await _loadUser();
        isAnonymous.value = false;
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 退出登录（退出后自动回到匿名）
  Future<void> logout() async {
    try { await _userProvider.logout(); } catch (_) {}
    await _storage.clear();
    user.value = UserModel.empty();
    isLoggedIn.value = false;
    isAnonymous.value = false;
    // 退出后自动匿名登录
    await loginAnonymous();
  }

  /// 需要真实登录时检查（匿名状态弹登录页）
  bool requireLogin() {
    if (isAnonymous.value) {
      Get.toNamed('/login');
      return false;
    }
    return true;
  }
}
