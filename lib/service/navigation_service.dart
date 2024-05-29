import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/icons/home_navi_icons.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/search_delegate.dart';

enum Navigation { naverMap, community, place, chatting, info }

class NavigationProvider extends GetxService {
  static NavigationProvider get to => Get.find();

  RxInt currentIndex = 0.obs;
  final Rx<int> visible = Rx<int>(personBox.get('person')!.visible);

  int get getVisible => visible.value;
  set setVisible(int v) => visible(v);

  void changeIndex(int idx) {
    currentIndex(idx);
  }

  Widget mapAppbarButton(String text, Future Function() onTap) {
    return Container(
      height: 52,
      decoration: enableButton,
      child: MaterialButton(
        animationDuration: Durations.short4,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          onTap();
        },
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget mapAppbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            mapAppbarButton('인구해변',
                () async => await CustomNaverMapController.to.moveFirstHole()),
            const SizedBox(width: 8),
            mapAppbarButton('서피비치',
                () async => await CustomNaverMapController.to.moveSecondHole()),
          ],
        ),
        AnimatedToggleSwitch.size(
          height: 30,
          borderWidth: 2,
          indicatorSize: const Size.fromWidth(26),
          current: CustomNaverMapController.to.getVisible,
          values: const [1, 0],
          onTap: (i) => CustomNaverMapController.to.visibleUpdate(),
          style: ToggleStyle(
            backgroundColor: Colors.white,
            borderColor: pointColor.withOpacity(0.5),
          ),
          styleBuilder: (value) =>
              ToggleStyle(indicatorColor: value == 1 ? pointColor : grey300),
        ),
      ],
    );
  }

  Widget communityAppbar() {
    switch (CommunityController.to.pageState.value) {
      case PageState.noticePage:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Container()),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final result = await showSearch(
                      context: Get.context!,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  icon: const Icon(HomeNavi.search),
                ),
                IconButton(onPressed: () {}, icon: const Icon(HomeNavi.heart)),
                IconButton(onPressed: () {}, icon: const Icon(HomeNavi.bell)),
              ],
            )
          ],
        );
      case PageState.classPage:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => CommunityController.to.initialPage(),
                icon: const Icon(Icons.arrow_back)),
            IconButton(
              onPressed: () async {
                final result = await showSearch(
                  context: Get.context!,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(HomeNavi.search),
            ),
          ],
        );
    }
  }

  Widget emptyAppbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Container()),
        const Row(children: []),
      ],
    );
  }

  PreferredSizeWidget selectAppBar(Navigation currentNavigation) {
    switch (currentNavigation) {
      case Navigation.naverMap:
        return homeAppbar(Navigation.naverMap, mapAppbar());
      case Navigation.community:
        return homeAppbar(Navigation.community, communityAppbar());
      case Navigation.place:
        return homeAppbar(Navigation.place, emptyAppbar());
      case Navigation.chatting:
        return homeAppbar(Navigation.chatting, emptyAppbar());
      case Navigation.info:
        return homeAppbar(Navigation.chatting, emptyAppbar());
    }
  }
}
