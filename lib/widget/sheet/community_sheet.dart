import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showSubjectSheet(List<dynamic> list, VoidCallback callback) async {
  return await Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            height: 50,
            child: const Text(
              '동네생활 주제',
              style: TextStyle(fontSize: 18, height: 1),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: list.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Text(
                        '${list[index]['id']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () async {
                        callback();
                        Get.back();
                        await Get.toNamed(
                          '/home/community_notice',
                          arguments: list[index]['id'],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
    ignoreSafeArea: true,
    backgroundColor: Colors.transparent,
  );
}
