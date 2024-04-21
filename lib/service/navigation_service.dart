import 'package:get/get.dart';

enum Navigation { naverMap, community, place, chatting, info }

class NavigationProvider extends GetxService {
  static NavigationProvider get to => Get.find();

  RxInt currentIndex = 0.obs;

  void changeIndex(int idx) {
    currentIndex(idx);
  }
}
