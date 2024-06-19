import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/icons/tingicons_icons.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/person.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/search_delegate.dart';

enum Navigation { naverMap, community, place, chatting, info }

class NavigationProvider extends GetxService {
  static NavigationProvider get to => Get.find();

  RxInt currentIndex = 0.obs;
  final Rx<Person> person = Rx<Person>(personBox.get('person')!);

  Person get getPerson => person.value;

  void changeIndex(int idx) {
    currentIndex(idx);
  }

  Widget mapAppbarButton(String text, Future Function() onTap) {
    return Container(
      height: 28,
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
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget mapAppbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 3),
              child: Text(
                CustomNaverMapController.to.getReverseGeocoding,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, height: 1),
              ),
            ),
            Row(
              children: [
                mapAppbarButton(
                    '인구해변',
                    () async =>
                        await CustomNaverMapController.to.moveFirstHole()),
                const SizedBox(width: 8),
                mapAppbarButton(
                    '서피비치',
                    () async =>
                        await CustomNaverMapController.to.moveSecondHole()),
              ],
            ),
          ],
        ),
        AnimatedToggleSwitch.size(
          height: 26,
          borderWidth: 2,
          indicatorSize: const Size.fromWidth(24),
          current: CustomNaverMapController.to.getVisible,
          values: const [1, 0],
          onTap: (i) => CustomNaverMapController.to.visibleUpdate(),
          styleBuilder: (value) => ToggleStyle(
              indicatorColor: Colors.white,
              backgroundColor: value == 1 ? pointColor : grey300,
              borderColor: value == 1
                  ? pointColor.withOpacity(0.5)
                  : grey300.withOpacity(0.5)),
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
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 3),
              child: Text(
                CustomNaverMapController.to.getReverseGeocoding,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, height: 1),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await showSearch(
                      context: Get.context!,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  icon: const Icon(Tingicons.search),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Tingicons.heart)),
                IconButton(onPressed: () {}, icon: const Icon(Tingicons.bell)),
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
                await showSearch(
                  context: Get.context!,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(Tingicons.search),
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
