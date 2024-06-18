import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
      if (item == null) {
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(color: pointColor),
          ),
        );
      } else {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Obx(
              () => registerAppbar(
                  '동네생활 글쓰기', controller.getDetail?.aka != '', () {}),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Obx(
                      () => Skeletonizer(
                        enabled: controller.getIsLoading,
                        enableSwitchAnimation: true,
                        justifyMultiLineText: false,
                        child: ListView(
                          children: [
                            nboDetailSubjectBadge(item),
                            nboDetailProfile(item, controller.getIsLoading),
                            nboDetailContent(item, controller),
                            nboDetailComment(item)
                          ],
                        ),
                      ),
                    )),
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
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Obx(() {
                          final isFocus = controller.getCommentFocus;
                          return TextField(
                            controller: controller.commentController,
                            focusNode: controller.commentFocus,
                            smartDashesType: SmartDashesType.enabled,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              hintText: '댓글을 입력하세요',
                              filled: true,
                              fillColor: pointColor.withAlpha(20),
                              suffixIcon: isFocus
                                  ? IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      icon: const Icon(Icons.send),
                                      color: pointColor,
                                      onPressed: () async {
                                        await controller.commentSubmit();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: pointColor),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: pointColor),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: pointColor),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
