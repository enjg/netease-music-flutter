import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/services/player_service.dart';
import '../home/home_page.dart';
import '../podcast/podcast_page.dart';
import '../mine/mine_page.dart';
import '../follow/follow_page.dart';
import '../account/account_page.dart';

class MainController extends GetxController {
  final playerService = Get.find<PlayerService>();
  final currentIndex = 0.obs;
  late final PageController pageController;

  final tabs = [
    {'icon': Icons.home_rounded, 'label': '发现'},
    {'icon': Icons.mic_rounded, 'label': '播客'},
    {'icon': Icons.person_rounded, 'label': '我的'},
    {'icon': Icons.people_rounded, 'label': '关注'},
    {'icon': Icons.menu_rounded, 'label': '账号'},
  ];

  final pages = const <Widget>[
    HomePage(),
    PodcastPage(),
    MinePage(),
    FollowPage(),
    AccountPage(),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }
}
