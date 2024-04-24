import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_style.dart';

AppBar commonAppbar({bool? isBack}) {
  return AppBar(
    leading: isBack == false
        ? null
        : IconButton(
            icon: Icon(Icons.arrow_back, color: grey500),
            onPressed: () => Get.back(),
          ),
  );
}
