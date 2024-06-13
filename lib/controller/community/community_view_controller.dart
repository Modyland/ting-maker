import 'package:get/get.dart';
import 'package:ting_maker/model/nbo_detail.dart';

class CommunityViewController extends GetxController {
  final Rx<NboDetail> detail = Rx(Get.arguments);

  NboDetail get getDetail => detail.value;
}
