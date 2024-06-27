import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/icons/ting_icons_icons.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/person.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/search_delegate.dart';

enum Navigation { naverMap, community, place, chatting, info }

class NavigationProvider extends GetxService {
  static NavigationProvider get to => Get.find();
  final Rx<int> currentIndex = Rx<int>(0);
  final Rx<Person> person = Rx<Person>(personBox.get('person')!);
  final RxList nboLikes = RxList([]);
  final RxList commentLikes = RxList([]);
  final RxList repleLikes = RxList([]);

  Person get getPerson => person.value;
  RxList get getNboLikes => nboLikes;
  RxList get getCommentLikes => commentLikes;
  RxList get getRepleLikes => repleLikes;

  @override
  void onReady() async {
    super.onReady();
    await getLikeList();
  }

  Future<void> getLikeList() async {
    try {
      final req = {'kind': 'Check_Likes', 'id': getPerson.id};

      final res = await service.updateLikes(req);
      nboLikes(res.body['nboLikes']);
      commentLikes(res.body['commentLikes']);
      repleLikes(res.body['cmtCmtLikes']);
    } catch (err) {
      log(err.toString());
    }
  }

  void changeIndex(int idx) {
    currentIndex(idx);
  }

  Widget mapAppbarButton(String text, Future Function() onTap) {
    return Container(
      height: 24,
      decoration: enableButton,
      child: MaterialButton(
        animationDuration: Durations.short4,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          onTap();
        },
        child: Center(
          child: Text(
            text,
            style:
                const TextStyle(fontSize: 14, color: Colors.white, height: 1.2),
          ),
        ),
      ),
    );
  }

  Widget mapAppbar() {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CustomNaverMapController.to.getReverseGeocoding,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black87, height: 1),
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
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: AnimatedToggleSwitch.size(
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
          ),
        ],
      ),
    );
  }

  Widget communityAppbar() {
    switch (CommunityController.to.pageState.value) {
      case PageState.noticePage:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  splashRadius: 15,
                  onPressed: () async {
                    await showSearch(
                      context: Get.context!,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  icon: const Icon(TingIcons.search),
                ),
                IconButton(
                    splashRadius: 15,
                    onPressed: () {},
                    icon: const Icon(TingIcons.favorite)),
                IconButton(
                    splashRadius: 15,
                    onPressed: () {},
                    icon: const Icon(TingIcons.bell)),
              ],
            )
          ],
        );
      case PageState.classPage:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                splashRadius: 15,
                onPressed: () => CommunityController.to.initialPage(),
                icon: const Icon(Icons.arrow_back)),
            IconButton(
              splashRadius: 15,
              onPressed: () async {
                await showSearch(
                  context: Get.context!,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(TingIcons.search),
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
