import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/util/f_logger.dart';

class RouterObserver extends GetObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == '/protectedPage') {
      Get.offAllNamed('/login');
    } else {
      Log.d('Route push: ${route.settings.name}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Log.d('Route popped: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    Log.d('Route replaced: ${newRoute?.settings.name}');
  }
}
