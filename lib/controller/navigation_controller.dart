import 'package:get/get.dart';

enum Navigation {
  naverMap,
  community,
}

class NavigationController extends GetxService {
  static NavigationController get to => Get.find();

  RxInt currentIndex = 0.obs;

  void changeIndex(int idx) {
    currentIndex(idx);
  }
}
