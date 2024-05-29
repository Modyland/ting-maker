import 'package:flutter/material.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/widget/common_style.dart';

class ClassListWidget extends StatelessWidget {
  const ClassListWidget({
    super.key,
    required this.controller,
  });

  final CommunityController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0XAAD4D4D4),
        border: Border.all(
          color: grey300,
          width: 1,
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.classList.length,
        itemBuilder: (context, idx) {
          return InkWell(
            onTap: () =>
                controller.goingClassPage(controller.classList[idx]['id']!),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 53,
                      width: 53,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(controller.classList[idx]['id']!),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
