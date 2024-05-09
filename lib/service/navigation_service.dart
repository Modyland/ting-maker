import 'package:get/get.dart';
import 'package:ting_maker/controller/map_controller.dart';

enum Navigation { naverMap, community, place, chatting, info }

class NavigationProvider extends GetxService {
  static NavigationProvider get to => Get.find();
  final CustomNaverMapController _naverMapController =
      Get.find<CustomNaverMapController>();

  RxInt currentIndex = 0.obs;

  void changeIndex(int idx) {
    currentIndex(idx);
    if (currentIndex.value != Navigation.naverMap.index) {
      _naverMapController.stopCameraTimer();
      _naverMapController.stopPositionStream();
    }
  }
}
