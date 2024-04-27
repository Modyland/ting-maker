import 'dart:async';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/util/logger.dart';

class CustomNaverMapController extends GetxController {
  final Rx<NaverMapController?> _mapController = Rx<NaverMapController?>(null);
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final Rx<Position?> _position = Rx<Position?>(null);
  final Rxn<NCameraUpdateReason> _cameraReason = Rxn<NCameraUpdateReason>();
  final Rx<StreamSubscription<Position>?> _positionStream =
      Rx<StreamSubscription<Position>?>(null);
  final StreamController<NCameraUpdateReason> _cameraStream =
      StreamController<NCameraUpdateReason>.broadcast();

  @override
  void onInit() {
    super.onInit();
    determinePosition();
    onCameraUpdate();
  }

  @override
  void onClose() {
    getPositionStream?.cancel();
    getCameraStream.close();
    getMapController?.dispose();
    super.onClose();
  }

  NaverMapController? get getMapController => _mapController.value;
  StreamSubscription<Position>? get getPositionStream => _positionStream.value;
  StreamController<NCameraUpdateReason> get getCameraStream => _cameraStream;
  Position? get getCurrentPosition => _currentPosition.value;
  Position? get getPosition => _position.value;

  set setMapController(NaverMapController? controller) =>
      _mapController.value = controller;
  set setPosition(Position position) => _position.value = position;

  Future<void> determinePosition() async {
    await locationPermissionCheck();

    // 현재 위치 스트림 연결
    _positionStream.value = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(),
    ).listen((Position position) async {
      setPosition = position;
      Log.f(position);
    });

    // 현재 위치 가져오기
    final position = await Geolocator.getCurrentPosition();
    _currentPosition.value = position;
  }

  void onCameraUpdate() {
    _cameraStream.stream.listen((NCameraUpdateReason reason) {
      _cameraReason.value = reason;
    }).onError((error) {
      Log.e("CameraStream Error: $error");
    });
  }

  // void test() async {
  //   final position = _customNaverMapController.getPosition;
  //   List<Placemark> placemark =
  //       await placemarkFromCoordinates(position!.latitude, position.longitude);
  //   Log.f(
  //     '${placemark[0]}, ${placemark[0].subLocality}, ${placemark[0].thoroughfare}',
  //   );
  //   NMarker marker1 = NMarker(
  //     id: '1',
  //     position: NLatLng(position.latitude, position.longitude),
  //   );
  //   NCircleOverlay circle = NCircleOverlay(
  //     id: '2',
  //     center: NLatLng(position.latitude, position.longitude),
  //   );
  //   if (_customNaverMapController.getMapController != null) {
  //     await _customNaverMapController.getMapController?.addOverlay(circle);
  //     await _customNaverMapController.getMapController?.addOverlay(marker1);
  //   }
  // }

  // void cameraChangeStream() {
  //   _onCameraChangeStreamController.stream.listen((reason) {
  //     Log.f(reason);
  //   });
  // }
}
