import 'package:get/get.dart';
import 'musician_controller.dart';
class MusicianBinding extends Bindings { @override void dependencies() { Get.lazyPut(() => MusicianController(), fenix: true); } }
