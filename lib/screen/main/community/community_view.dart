import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ting_maker/controller/community/community_view_controller.dart';
import 'package:ting_maker/util/image.dart';
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
                if (controller.regiImage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    height: 76,
                    decoration: BoxDecoration(
                      color: grey100,
                      border: Border(
                        top: BorderSide(color: grey200),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          controller.regiImage.length,
                          (v) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 4, top: 4),
                                  height: 60,
                                  width: 60,
                                  clipBehavior: Clip.none,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(width: 1, color: pointColor),
                                    image: DecorationImage(
                                      image:
                                          MemoryImage(controller.regiImage[v]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      controller.regiImage.removeAt(v);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: grey500,
                                        borderRadius: BorderRadius.circular(
                                          50,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: grey100,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
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
                        onPressed: () async {
                          await ImagePickerProvider.showImageOptions(
                            context,
                            controller.regiImage,
                          );
                        },
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
                                    ? '답글을 남겨주세요.'
                                    : '댓글을 입력해주세요.',
                                filled: true,
                                fillColor: pointColor.withAlpha(20),
                                suffixIcon: isFocus ||
                                        controller.regiImage.isNotEmpty ||
                                        controller
                                            .commentController.text.isNotEmpty
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
