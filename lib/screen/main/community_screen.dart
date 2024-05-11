import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community_controller.dart';

class CommunityScreen extends GetView<CommunityController> {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  controller.tabBar(),
                  const SizedBox(height: 25),
                  controller.getTab == 'id'
                      ? const Text('id')
                      : const Text('pwd')
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
