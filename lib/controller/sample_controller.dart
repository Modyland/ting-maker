import 'dart:math';

import 'package:get/get.dart';

class SampleController extends GetxController with StateMixin {
  final RxString _sample = '성공했어요.'.obs;
  RxString get sample => _sample;

  @override
  void onInit() {
    getSample();
    super.onInit();
  }

  void getSample() async {
    change(null, status: RxStatus.loading());

    await Future.delayed(const Duration(seconds: 1));

    final randomNum = Random();
    switch (randomNum.nextInt(3)) {
      case 0:
        change(null, status: RxStatus.empty());
        break;
      case 1:
        change(null, status: RxStatus.error('예외 발생 !'));
        break;
      case 2:
        change(null, status: RxStatus.success());
        break;
    }
  }
}
