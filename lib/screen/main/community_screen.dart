import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/model/nbo_list.dart';
import 'package:ting_maker/widget/common_style.dart';
// import 'package:ting_maker/widget/community/class_list.dart';
import 'package:ting_maker/widget/community/nbo_item.dart';
import 'package:ting_maker/widget/community/subject_list.dart';

class CommunityScreen extends GetView<CommunityController> {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const textButtonStyle = TextStyle(
      fontSize: 16,
      height: 1,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
    return Obx(
      () => PopScope(
        canPop: !controller.isClassPage,
        onPopInvoked: (bool value) {
          if (!value) {
            controller.initialPage();
          }
        },
        child: Obx(
          () {
            if (controller.pageState.value == PageState.noticePage) {
              return Stack(
                children: [
                  Column(
                    children: [
                      // ClassListWidget(controller: controller),
                      SubjectListWidget(controller: controller),
                      Flexible(child: nboInfiniteList())
                    ],
                  ),
                  Positioned(
                    bottom: 15,
                    right: 20,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shadowColor: grey200,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        backgroundColor: pointColor,
                      ),
                      child: const Text('+ 글쓰기', style: textButtonStyle),
                      onPressed: () async {
                        await Get.toNamed('/home/community_regi');
                      },
                    ),
                  )
                ],
              );
            } else {
              return Container(
                child: Column(
                  children: [
                    tabBar(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  TabBar tabBar() {
    return TabBar(
      controller: controller.tabController,
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

  RefreshIndicator nboInfiniteList() {
    return RefreshIndicator(
      color: pointColor,
      onRefresh: () async {
        controller.nboList.clear();
        controller.getPagingController.refresh();
      },
      child: PagedListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        pagingController: controller.getPagingController,
        builderDelegate: PagedChildBuilderDelegate<Rx<NboList>>(
          itemBuilder: (context, item, idx) {
            return Obx(() => nboItem(context, item.value, controller.goDetail));
          },
          firstPageProgressIndicatorBuilder: (context) {
            return Center(
              child: CircularProgressIndicator(color: pointColor),
            );
          },
          newPageProgressIndicatorBuilder: (context) {
            return Center(
              child: CircularProgressIndicator(color: pointColor),
            );
          },
          firstPageErrorIndicatorBuilder: (context) {
            return Center(
              child: TextButton(
                onPressed: () => controller.getPagingController.refresh(),
                child: const Text('다시 시도'),
              ),
            );
          },
          newPageErrorIndicatorBuilder: (context) {
            return Center(
              child: TextButton(
                onPressed: () =>
                    controller.getPagingController.retryLastFailedRequest(),
                child: const Text('다시 시도'),
              ),
            );
          },
        ),
      ),
    );
  }
}
