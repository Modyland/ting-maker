import 'package:get/get.dart';
import 'package:ting_maker/controller/community/community_notice_single_controller.dart';
import 'package:ting_maker/controller/community/community_regi_controller.dart';
import 'package:ting_maker/controller/community/community_view_controller.dart';

class CommunityViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunityViewController());
  }
}

class CommunityRegiBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunityRegiController());
  }
}

class CommunityNoticeSingleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunityNoticeSingleController());
  }
}
