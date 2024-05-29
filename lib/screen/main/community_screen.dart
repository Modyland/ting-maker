import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/icons/home_navi_icons.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/community/class_list.dart';
import 'package:ting_maker/widget/community/subject_list.dart';

class CommunityScreen extends GetView<CommunityController> {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      ClassListWidget(controller: controller),
                      SubjectListWidget(controller: controller),
                      Flexible(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            controller.getPagingController.refresh();
                          },
                          child: PagedListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            pagingController: controller.getPagingController,
                            builderDelegate: PagedChildBuilderDelegate<dynamic>(
                              itemBuilder: (context, item, index) =>
                                  Container(),
                              firstPageErrorIndicatorBuilder: (context) =>
                                  Center(
                                child: TextButton(
                                  onPressed: () =>
                                      controller.getPagingController.refresh(),
                                  child: const Text('다시 시도'),
                                ),
                              ),
                              newPageErrorIndicatorBuilder: (context) => Center(
                                child: TextButton(
                                  onPressed: () => controller
                                      .getPagingController
                                      .retryLastFailedRequest(),
                                  child: const Text('다시 시도'),
                                ),
                              ),
                              firstPageProgressIndicatorBuilder: (context) =>
                                  const Center(
                                      child: CircularProgressIndicator()),
                              newPageProgressIndicatorBuilder: (context) =>
                                  const Center(
                                      child: CircularProgressIndicator()),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        iconColor: Colors.white,
                        backgroundColor: pointColor,
                      ),
                      child: const Row(
                        children: [
                          Icon(HomeNavi.plus),
                          Text(
                            '글쓰기',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
                    controller.tabBar(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
