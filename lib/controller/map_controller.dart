import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CustomNaverMapController extends GetxController {
  final Rx<NaverMapController?> _mapController = Rx<NaverMapController?>(null);
  final Rx<Position?> _position = Rx<Position?>(null);

  Position? get getPosition => _position.value;

  set setPosition(Position position) => _position.value = position;

  NaverMapController? get getMapController => _mapController.value;

  set setMapController(NaverMapController? controller) =>
      _mapController.value = controller;
}
