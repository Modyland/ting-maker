import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community/community_view_controller.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/community/nbo_detail.dart';

class CommunityViewScreen extends GetView<CommunityViewController> {
  const CommunityViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.getDetail;
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(
            () => registerAppbar(
                '동네생활 글쓰기', controller.getDetail.aka != '', () {}),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    nboDetailSubjectBadge(item),
                    nboDetailProfile(item),
                    nboDetailContent(item, controller),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: grey200),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: grey400),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.commentController,
                      decoration: const InputDecoration(
                        hintText: '댓글을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
