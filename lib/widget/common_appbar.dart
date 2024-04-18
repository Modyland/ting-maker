import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar commonAppbar() {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xff717680)),
      onPressed: () => Get.back(),
    ),
  );
}
