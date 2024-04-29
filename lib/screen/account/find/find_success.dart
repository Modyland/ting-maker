import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_appbar.dart';

class FindSuccessScreen extends StatefulWidget {
  const FindSuccessScreen({super.key});

  @override
  State<FindSuccessScreen> createState() => _FindSuccessScreenState();
}

class _FindSuccessScreenState extends State<FindSuccessScreen> {
  Map<String, dynamic> registerData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: const Center(),
    );
  }
}
