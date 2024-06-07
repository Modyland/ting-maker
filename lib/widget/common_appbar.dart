import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/service/navigation_service.dart';
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

AppBar dialogAppbar(String title, bool isReady) {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 3,
    leading: IconButton(
      icon: Icon(Icons.close, color: grey500),
      onPressed: () => Get.back(),
    ),
    title: Center(
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            height: 1),
      ),
    ),
    actions: [
      TextButton(
        child: Text(
          '완료',
          style: TextStyle(
              color: isReady ? Colors.black : grey300,
              fontSize: 16,
              fontWeight: FontWeight.w300,
              height: 1),
        ),
        onPressed: () {},
      ),
    ],
  );
}

AppBar homeAppbar(
  Navigation navigation,
  Widget child, {
  double? ele,
}) {
  switch (navigation) {
    case Navigation.naverMap:
      return AppBar(
        elevation: ele ?? 3,
        scrolledUnderElevation: ele ?? 3,
        flexibleSpace: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: child,
          ),
        ),
      );
    case Navigation.community:
      return AppBar(
        elevation: ele ?? 1,
        scrolledUnderElevation: ele ?? 1,
        flexibleSpace: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      );
    case Navigation.place:
      return AppBar(
        elevation: ele ?? 3,
        scrolledUnderElevation: ele ?? 3,
        flexibleSpace: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      );
    case Navigation.chatting:
      return AppBar(
        elevation: ele ?? 3,
        scrolledUnderElevation: ele ?? 3,
        flexibleSpace: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      );
    case Navigation.info:
      return AppBar(
        elevation: ele ?? 3,
        scrolledUnderElevation: ele ?? 3,
        flexibleSpace: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      );
  }
}
