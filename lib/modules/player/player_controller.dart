import 'package:get/get.dart';
import '../../shared/services/player_service.dart';

class PlayerController extends GetxController {
  final playerService = Get.find<PlayerService>();

  void togglePlay() => playerService.togglePlay();
  void next() => playerService.next();
  void prev() => playerService.prev();
  void seek(double v) => playerService.seek(v);
  void toggleMode() => playerService.togglePlayMode();
}
