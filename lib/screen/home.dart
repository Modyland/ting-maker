import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/screen/main/chatting_screen.dart';
import 'package:ting_maker/screen/main/community_screen.dart';
import 'package:ting_maker/screen/main/map_screen.dart';
import 'package:ting_maker/screen/main/myinfo_screen.dart';
import 'package:ting_maker/screen/main/myplace_screen.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class MainScreen extends GetView<NavigationProvider>
    with WidgetsBindingObserver {
  const MainScreen({super.key});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Log.e("앱이 표시되고 사용자 입력에 응답합니다");
        break;
      case AppLifecycleState.inactive:
        Log.e("앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다");
        break;
      case AppLifecycleState.detached:
        Log.e("모든 뷰가 제거되고 플러터 엔진만 동작 중이며 앱이 종료되기 직전에 실행됩니다");
        break;
      case AppLifecycleState.paused:
        Log.e("앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다");
        break;
      case AppLifecycleState.hidden:
        Log.e('hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppbar(isBack: false),
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
              ]),
        ));
  }
}
