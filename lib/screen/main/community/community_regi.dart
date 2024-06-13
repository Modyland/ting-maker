import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community/community_regi_controller.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/util/overlay.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class CommunityRegiScreen extends GetView<CommunityRegiController> {
  const CommunityRegiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => registerAppbar(
              '동네생활 글쓰기',
              controller.getSubject.isNotEmpty &&
                  controller.getTitle.isNotEmpty &&
                  controller.getContent.isNotEmpty, () async {
            OverlayManager.showOverlay(context);
            await controller.registerSubmit();
          }),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 52),
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Form(
                            child: Column(
                              children: [
                                Obx(() => subjectSelectButton()),
                                titleInput(),
                                contentInput(),
                                Obx(() => imageInput()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                footer(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Positioned footer(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 0,
      right: 0,
      child: Container(
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
            TextButton(
              style: TextButton.styleFrom(
                iconColor: grey400,
                backgroundColor: Colors.transparent,
              ),
              child: Row(
                children: [
                  const Icon(Icons.image),
                  const SizedBox(width: 4),
                  Text(
                    '사진',
                    style: TextStyle(color: grey400, height: 1),
                  ),
                ],
              ),
              onPressed: () {
                controller.showImageOptions();
              },
            ),
          ],
        ),
      ),
    );
  }

  Expanded imageInput() {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              controller.regiImage.length,
              (v) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      height: MyApp.width * 0.16,
                      width: MyApp.width * 0.16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: MemoryImage(
                            controller.regiImage[v],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 3,
                      right: 11,
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
        ],
      ),
    );
  }

  TextFormField contentInput() {
    return TextFormField(
      style: const TextStyle(fontSize: 15, height: 1),
      minLines: 10,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        hintText: '내용을 입력하세요',
        hintStyle: TextStyle(color: grey300, fontSize: 15, height: 1),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      onChanged: (value) {
        controller.setContent = value;
      },
    );
  }

  TextFormField titleInput() {
    return TextFormField(
      style: const TextStyle(fontSize: 18, height: 1),
      minLines: 1,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        hintText: '제목을 입력하세요',
        hintStyle: TextStyle(color: grey300, fontSize: 18, height: 1),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      onChanged: (value) {
        controller.setTitle = value;
      },
    );
  }

  InkWell subjectSelectButton() {
    return InkWell(
      onTap: () async {
        await controller.showSubjectSheetList();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 60,
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(width: 1, color: grey200),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.getSubject == ''
                ? '게시글의 주제를 선택해주세요.'
                : controller.getSubject),
            Transform.rotate(
              angle: pi,
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
