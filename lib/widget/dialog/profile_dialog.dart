import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/marker_img.dart';

Future<void> showProfileDialog(String idx) async {
  return await Get.dialog(
    Center(
      child: Container(
        width: MyApp.width * 0.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: pointColor.withAlpha(100),
          image: DecorationImage(
            fit: BoxFit.contain,
            image: markerImg(int.tryParse(idx)!).image,
          ),
        ),
      ),
    ),
    barrierColor: Colors.black45,
  );
}
