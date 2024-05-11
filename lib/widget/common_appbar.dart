import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_style.dart';

AppBar commonAppbar() {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 3,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: grey500),
      onPressed: () => Get.back(),
    ),
  );
}

AppBar mapAppbar(String place, {double? ele}) {
  return AppBar(
    elevation: ele ?? 3,
    scrolledUnderElevation: ele ?? 3,
    flexibleSpace: SizedBox(
      width: double.infinity,
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(place),
          ],
        ),
      ),
    ),
  );
}
