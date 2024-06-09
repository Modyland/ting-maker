import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/icons/tingicons_icons.dart';
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => controller
              .selectAppBar(Navigation.values[controller.currentIndex.value]),
        ),
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            NaverMapScreen(),
            CommunityScreen(),
            MyPlaceScreen(),
            ChattingScreen(),
            MyInfoScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 21,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.black87,
          unselectedItemColor: grey300,
          selectedLabelStyle: const TextStyle(height: 1.2, fontSize: 13),
          unselectedLabelStyle: const TextStyle(height: 1.2, fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Tingicons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Tingicons.newspaper),
              label: '동네',
            ),
            BottomNavigationBarItem(
              icon: Icon(Tingicons.place),
              label: '내 근처',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Tingicons.commenting_o,
              ),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Tingicons.user,
              ),
              label: '내정보',
            ),
          ],
        ),
      ),
    );
  }
}
