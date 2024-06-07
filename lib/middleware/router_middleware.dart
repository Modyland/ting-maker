import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/person.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

Future initLoginCheck() async {
  try {
    final isLogin = utilBox.get('isLogin') ?? false;
    final person = personBox.get('person');
    if (isLogin && person != null) {
      final Map<String, dynamic> requestData = {
        'kind': 'login',
        'id': '',
        'guard': 1
      };
      requestData['id'] = person.id;
      final res = await service.tingApiGetdata(requestData);
      final data = json.decode(res.bodyString!);
      if (data is Map<String, dynamic> && data.containsKey('profile')) {
        final profile = json.decode(data['profile']);
        final Person person = Person.fromJson(profile);
        await personBox.put('person', person);
        return true;
      } else {
        return false;
      }
    }
  } catch (err) {
    titleSnackbar('로그인 오류', '접속이 원활하지 않습니다.');
  }
}

Future<void> locationPermissionCheck() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    titleSnackbar('위치', '위치서비스를 사용해 주세요.');
    await Geolocator.openLocationSettings();
    return Future.error('위치 사용 안함');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      titleSnackbar('위치 권한', '위치 권한을 허용해주세요.');
      await Geolocator.openAppSettings();
      return Future.error('위치 권한 거부');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    titleSnackbar('위치 권한', '앱 위치권한을 허용해주세요.');
    await Geolocator.openAppSettings();
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
