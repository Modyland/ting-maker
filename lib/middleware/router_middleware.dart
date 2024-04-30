import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/user_model.dart';
import 'package:ting_maker/util/toast.dart';
import 'package:ting_maker/widget/common_style.dart';

Future initLoginCheck() async {
  final isLogin = pref.getBool('isLogin') ?? false;
  final user = pref.getString('user');
  if (isLogin && user != null) {
    final Map<String, dynamic> requestData = {
      'kind': 'login',
      'id': '',
      'guard': 1
    };
    final userData = json.decode(user);
    final UserModel userModel = UserModel.fromJson(userData);
    requestData['id'] = userModel.id;
    final res = await service.tingApiGetdata(requestData);
    final data = json.decode(res.bodyString!);
    if (data is Map<String, dynamic> && data.containsKey('profile')) {
      final profile = json.decode(data['profile']);
      final UserModel user = UserModel.fromJson(profile);
      final isSave = await pref.setString(
        'user',
        json.encode(user.toJson()),
      );
      return isSave;
    } else {
      return false;
    }
  }
}

Future<void> locationPermissionCheck() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    await normalToast('디바이스 위치를 활성화 해주세요.', pointColor);
    return Future.error('위치 꺼놨을때');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await normalToast('앱 위치권한을 허용해주세요.', pointColor);
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.openAppSettings();
      return Future.error('위치 권한 거부');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openAppSettings();
    await normalToast('앱 위치권한을 허용해주세요.', pointColor);
    return Future.error('영구적으로 거부');
  }
}

class RouterObserver extends GetObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    if (previousRoute == null && route.settings.name == '/home') {
      final check = await initLoginCheck();
      if (!check) {
        Get.offAllNamed('/login');
      }
    }
    if (previousRoute?.settings.name == '/login' &&
        route.settings.name == '/home') {
      await locationPermissionCheck();
    }
  }
}
