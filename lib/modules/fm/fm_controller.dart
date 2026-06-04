import 'package:get/get.dart';
import '../../data/providers/song_provider.dart';
import '../../data/models/song_model.dart';

class FmController extends GetxController {
  final _provider = SongProvider();
  final currentSong = Rx<SongModel?>(null);
  final isPlaying = true.obs;
  final progress = 0.0.obs;
  final isLiked = false.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFm();
  }

  Future<void> loadFm() async {
    isLoading.value = true;
    // FM API需要登录，先用默认数据
    currentSong.value = SongModel(
      id: 0, name: '私人FM', artists: ['网易云音乐'], artistIds: [],
      albumName: '', albumId: '', coverUrl: '', duration: 240000, fee: 0,
    );
    isLoading.value = false;
  }

  void togglePlay() => isPlaying.value = !isPlaying.value;
  void next() => loadFm();
  void toggleLike() => isLiked.value = !isLiked.value;
}
