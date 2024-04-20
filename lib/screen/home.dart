import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/navigation_controller.dart';
import 'package:ting_maker/screen/community_screen.dart';
import 'package:ting_maker/screen/map_screen.dart';
import 'package:ting_maker/widget/common_appbar.dart';

class MainScreen extends GetView<NavigationController> {
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppbar(),
        body: Obx(() {
          switch (Navigation.values[controller.currentIndex.value]) {
            case Navigation.naverMap:
              return const NaverMapScreen();
            case Navigation.community:
              return const CommunityScreen();
          }
        }),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              showSelectedLabels: true,
              onTap: controller.changeIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(Icons.home),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(Icons.home),
                  label: '로그인',
                ),
              ]),
        ));
  }
}
