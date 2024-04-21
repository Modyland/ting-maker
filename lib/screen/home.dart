import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/screen/chatting.dart';
import 'package:ting_maker/screen/community_screen.dart';
import 'package:ting_maker/screen/map_screen.dart';
import 'package:ting_maker/screen/myinfo.dart';
import 'package:ting_maker/screen/myplace_screen.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/widget/common_appbar.dart';

class MainScreen extends GetView<NavigationProvider> {
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
            case Navigation.place:
              return const MyPlaceScreen();
            case Navigation.chatting:
              return const ChattingScreen();
            case Navigation.info:
              return const MyInfoScreen();
          }
        }),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.black,
              unselectedItemColor: const Color(0xffbcc0c6),
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
              ]),
        ));
  }
}
