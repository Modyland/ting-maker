import 'package:flutter/material.dart';
import 'package:get/get.dart';

final snackShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.5),
  spreadRadius: 1,
  blurRadius: 5,
  offset: const Offset(0, 3),
);

SnackbarController noTitleSnackbar(
  String message, {
  SnackPosition? snackPosition,
}) {
  return Get.rawSnackbar(
    dismissDirection: DismissDirection.horizontal,
    snackPosition: snackPosition ?? SnackPosition.TOP,
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.all(30),
    padding: const EdgeInsets.all(0),
    messageText: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [snackShadow],
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ),
  );
}

SnackbarController titleSnackbar(
  String title,
  String message, {
  SnackPosition? snackPosition,
}) {
  return Get.snackbar(
    title,
    message,
    boxShadows: [snackShadow],
    dismissDirection: DismissDirection.horizontal,
    snackPosition: snackPosition ?? SnackPosition.TOP,
    backgroundColor: Colors.white,
    borderRadius: 20,
    margin: const EdgeInsets.all(30),
  );
}
