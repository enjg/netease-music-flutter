import 'package:get/get.dart';
import 'artist_controller.dart';
class ArtistBinding extends Bindings { @override void dependencies() { Get.lazyPut(() => ArtistController()); } }
