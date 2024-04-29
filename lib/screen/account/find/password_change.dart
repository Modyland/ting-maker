import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/util/logger.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  Map<String, dynamic> registerData = Get.arguments;

  void changePassword() async {
    final Map<String, dynamic> requestData = {
      'kind': 'updatePWD',
      'id': '',
      'pwd': '',
    };
    final res = await service.tingApiGetdata(requestData);
    Log.e(res.statusCode);
    final data = json.decode(res.bodyString!);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
