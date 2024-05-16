import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/screen/main/chatting_screen.dart';
import 'package:ting_maker/screen/main/community_screen.dart';
import 'package:ting_maker/screen/main/map_screen.dart';
import 'package:ting_maker/screen/main/myinfo_screen.dart';
import 'package:ting_maker/screen/main/myplace_screen.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/widget/common_style.dart';

class MainScreen extends GetView<NavigationProvider> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(
            () => controller
                .selectAppBar(Navigation.values[controller.currentIndex.value]),
          ),
        ),
        body: Obx(
          () {
            switch (Navigation.values[controller.currentIndex.value]) {
              case Navigation.naverMap:
                return const NaverMapScreen();
              case Navigation.community:
                return const CommunityScreen();
              case Navigation.place:
                return const MyPlaceScreen();
              case Navigation.chatting:
                return const ChattingScreen();
              case Navigation.info:
                return const MyInfoScreen();
            }
          },
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: grey300,
            onTap: controller.changeIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '동네',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '내 근처',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '채팅',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '내정보',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
