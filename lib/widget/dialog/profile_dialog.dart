import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';

Future<void> showProfileDialog(String idx) async {
  return await Get.dialog(
    Center(
      child: Container(
        width: MyApp.width * 0.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.contain,
            image: ExtendedNetworkImageProvider(
              "http://db.medsyslab.co.kr:4500/ting/mapProfiles?idx=$idx",
            ),
          ),
        ),
      ),
    ),
    barrierColor: Colors.black45,
  );
}