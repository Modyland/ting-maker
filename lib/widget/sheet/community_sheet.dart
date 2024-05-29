import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showSubjectSheet(List<dynamic> list) async {
  return await Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
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
            height: 50,
          ),
          Flexible(
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
        ],
      ),
    ),
    ignoreSafeArea: true,
    backgroundColor: Colors.transparent,
  );
}
