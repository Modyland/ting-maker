import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community/community_regi_controller.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class CommunityRegiScreen extends GetView<CommunityRegiController> {
  const CommunityRegiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dialogAppbar('동네생활 글쓰기', false),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 50),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                onTap: () async {
                                  // await showSubjectSheet(list, callback)
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal:
                                          BorderSide(width: 1, color: grey200),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('게시글의 주제를 선택해주세요.'),
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
                              ),
                              TextFormField(
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: '제목을 입력하세요',
                                  hintStyle: TextStyle(color: grey300),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '제목을 입력해주세요';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                              TextFormField(
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: '내용을 입력하세요',
                                  hintStyle: TextStyle(color: grey300),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '내용을 입력해주세요';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: MaterialButton(
                      animationDuration: Durations.short4,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () async {},
                      child: const Center(
                        child: Text(
                          '인증 문자 받기',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
