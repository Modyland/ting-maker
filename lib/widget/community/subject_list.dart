import 'package:flutter/material.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/widget/common_style.dart';

class SubjectListWidget extends StatelessWidget {
  const SubjectListWidget({
    super.key,
    required this.controller,
  });

  final CommunityController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: grey300,
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.getSubjectList.length,
        itemBuilder: (context, idx) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () =>
                  controller.goingSubjectPage(controller.getSubjectList[idx]!),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: grey300,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.getSubjectList[idx]!,
                    style: const TextStyle(fontSize: 12, height: 1),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
