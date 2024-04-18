import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void datePickerBottomSheet() {
  Get.bottomSheet(
    SizedBox(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CupertinoButton(
                  child: const Text('취소'),
                  onPressed: () {},
                ),
                CupertinoButton(
                  child: const Text('완료'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: CupertinoDatePicker(
                backgroundColor: Colors.transparent,
                minimumYear: 1900,
                maximumYear: DateTime.now().year,
                initialDateTime: DateTime.now(),
                maximumDate: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime dateTime) {},
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    ignoreSafeArea: true,
  );
}
