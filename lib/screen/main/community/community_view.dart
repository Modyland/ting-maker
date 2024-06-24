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
          body: RefreshIndicator(
            color: pointColor,
            onRefresh: () async {
              await controller.detailInit();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Obx(
                        () => Skeletonizer(
                          enabled: controller.getIsLoading,
                          enableSwitchAnimation: true,
                          justifyMultiLineText: false,
                          child: ListView(
                            controller: controller.scrollController,
                            children: [
                              nboDetailSubjectBadge(item),
                              nboDetailProfile(item),
                              nboDetailContent(item, controller),
                              nboDetailComment(item, controller)
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
                              onSubmitted: (v) async {
                                await controller.commentSubmit();
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                hintText: controller.getReple
                                    ? '답변을 입력해주세요.'
                                    : '댓글을 입력해주세요.',
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
                      if (controller.getReple)
                        IconButton(
                          iconSize: 24,
                          constraints: const BoxConstraints(
                              maxWidth: 40,
                              maxHeight: 40,
                              minHeight: 40,
                              minWidth: 40),
                          padding: const EdgeInsets.all(0),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            controller.cancelReple();
                          },
                          icon: Icon(
                            Icons.close,
                            color: grey400,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
