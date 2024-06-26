import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/nbo_list.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/widget/sheet/community_sheet.dart';

enum PageState { noticePage, classPage }

enum TabState { all, schedule, my }

class CommunityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final limitSize = 10;
  static CommunityController get to => Get.find();
  final Rx<TabState> nowTab = TabState.all.obs;
  final Rx<PageState> pageState = PageState.noticePage.obs;
  final Rx<List> subjectList = Rx<List>(utilBox.get('subject')!);
  final RxList<Rx<NboList>> nboList = RxList<Rx<NboList>>([]);
  final PagingController<int, Rx<NboList>> _pagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, Rx<NboList>> get getPagingController =>
      _pagingController;
  TabState get getTab => nowTab.value;
  bool get isClassPage =>
      NavigationProvider.to.currentIndex.value == Navigation.community.index &&
      pageState.value == PageState.classPage;
  List get getSubjectList => subjectList.value;

  late TabController tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 300),
  );
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

  @override
  void onInit() {
    super.onInit();
    tabController.addListener(handleTabChange);
    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchPage(pageKey);
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
        (sub) {
          Get.back();
          Get.toNamed(
            '/home/community_notice',
            arguments: sub,
          );
        },
      );
    } else {
      Get.toNamed(
        '/home/community_notice',
        arguments: id,
      );
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await service.getNboSelect(
        limitSize,
        NavigationProvider.to.getPerson.id,
        idx: pageKey != 0 ? _pagingController.itemList?.last.value.idx : null,
      );
      if (newItems != null) {
        nboList.addAll(newItems.map((e) => e.obs));
        final startIndex = pageKey * limitSize;
        final endIndex = startIndex + newItems.length;
        final data = nboList.sublist(startIndex, endIndex);
        final isLastPage = newItems.length < limitSize;
        if (isLastPage) {
          _pagingController.appendLastPage(data);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(data, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> goDetail(int idx) async {
    Get.toNamed('/home/community_view',
        arguments: {'idx': idx, 'to': 'community'});
  }
}
