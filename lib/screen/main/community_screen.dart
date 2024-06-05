import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/community/class_list.dart';
import 'package:ting_maker/widget/community/nbo_list.dart';
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
                      ClassListWidget(controller: controller),
                      SubjectListWidget(controller: controller),
                      Flexible(
                        child: NboListWidget(controller: controller),
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
