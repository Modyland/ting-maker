import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_style.dart';

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
            image: ExtendedImage.network(
              "${service.baseUrl}ting/mapProfiles?idx=$idx",
              cache: true,
              cacheKey: 'markerImg$idx',
              imageCacheName: 'markerImg$idx',
              cacheMaxAge: const Duration(days: 3),
              loadStateChanged: (state) {
                if (state.extendedImageLoadState == LoadState.loading) {
                  return Center(
                      child: CircularProgressIndicator(color: pointColor));
                }
                return null;
              },
            ).image,
          ),
        ),
      ),
    ),
    barrierColor: Colors.black45,
  );
}
