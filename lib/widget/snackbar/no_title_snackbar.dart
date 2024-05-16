import 'package:flutter/material.dart';
import 'package:get/get.dart';

GetSnackBar noTitleSnackbar(String message) => GetSnackBar(
      title: '',
      message: '',
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.BOTTOM,
      messageText: Center(
          child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 30,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black87,
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ))),
      margin: const EdgeInsets.all(30),
    );
