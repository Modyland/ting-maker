import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/nbo.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/sheet/community_sheet.dart';

enum PageState { noticePage, classPage }

enum TabState { all, schedule, my }

class CommunityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static CommunityController get to => Get.find();
  final limitSize = 10;
  final PagingController<int, Nbo> _pagingController = PagingController(
    firstPageKey: 0,
  );
  Rx<TabState> nowTab = TabState.all.obs;
  Rx<PageState> pageState = PageState.noticePage.obs;

  final Rx<List> subjectList = Rx<List>(utilBox.get('subject')!);

  List get getSubjectList => subjectList.value;

  final List<Map<String, String>> classList = [
    {'id': '1'},
    {'id': '2'},
    {'id': '3'},
    {'id': '4'},
    {'id': '5'},
    {'id': '6'},
    {'id': '7'},
    {'id': '8'},
    {'id': '9'},
    {'id': '10'},
  ];

  late TabController tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 300),
  );

  PagingController<int, Nbo> get getPagingController => _pagingController;
  TabState get getTab => nowTab.value;
  bool get isClassPage =>
      NavigationProvider.to.currentIndex.value == Navigation.community.index &&
      pageState.value == PageState.classPage;
  TabBar tabBar() {
    return TabBar(
      controller: tabController,
      overlayColor: const WidgetStatePropertyAll(
        Colors.transparent,
      ),
      indicatorColor: pointColor,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      labelColor: Colors.black,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelColor: grey300,
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
      ),
      tabs: const [
        Tab(text: "전체 모임"),
        Tab(text: "모임 일정"),
        Tab(text: "내 모임"),
      ],
    );
  }

  @override
  void onInit() {
    super.onInit();
    tabController.addListener(handleTabChange);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void onClose() {
    _pagingController.dispose();
    super.onClose();
  }

  void initialPage() {
    pageState.value = PageState.noticePage;
  }

  void handleTabChange() {
    if (tabController.index == 0) {
      nowTab.value = TabState.all;
    } else if (tabController.index == 1) {
      nowTab.value = TabState.schedule;
    } else if (tabController.index == 2) {
      nowTab.value = TabState.my;
    }
  }

  void goingClassPage(String id) {
    if (id == '1') {
      pageState.value = PageState.classPage;
    } else {
      return;
    }
  }

  void goingSubjectPage(String id) async {
    if (id == '주제') {
      await showSubjectSheet(
        subjectList.value.where((e) => e != '주제').toList(),
        (sub) async {
          Get.back();
          await Get.toNamed(
            '/home/community_notice',
            arguments: sub,
          );
        },
      );
    } else {
      await Get.toNamed(
        '/home/community_notice',
        arguments: id,
      );
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await service.getNboSelect(
        limitSize,
        idx: pageKey != 0 ? _pagingController.itemList?.last.idx : null,
      );
      if (newItems != null) {
        final isLastPage = newItems.length < limitSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
}
