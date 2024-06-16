import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showSubjectSheet(
  List<dynamic> list,
  Future<void> Function(String sub) callback,
) async {
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
                itemBuilder: (context, idx) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Text(
                        '${list[idx]}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () async {
                        await callback(list[idx]);
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
