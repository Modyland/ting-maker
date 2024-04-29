import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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

  IO.Socket socket = IO.io(
      dotenv.get('TEST_SOCKET'),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  @override
  void onInit() {
    super.onInit();
    determinePosition();
    onCameraUpdate();
    socketInit();
  }

  @override
  void onClose() {
    getPositionStream?.cancel();
    getCameraStream.close();
    getMapController?.dispose();
    super.onClose();
  }

  void socketInit() {
    socket.onConnect((_) {
      Log.f('connect');
    });
    socket.onDisconnect((_) {
      Log.e('disconnect');
    });
    socket.on('test', (data) {
      Log.e(data);
    });
    socket.connect();
  }

  NaverMapController? get getMapController => _mapController.value;
  StreamSubscription<Position>? get getPositionStream => _positionStream.value;
  StreamController<NCameraUpdateReason> get getCameraStream => _cameraStream;
  Position? get getCurrentPosition => _currentPosition.value;
  Position? get getPosition => _position.value;
  IO.Socket get getSocket => socket;

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
    _cameraStream.stream.listen((NCameraUpdateReason reason) async {
      _cameraReason.value = reason;
      Log.e((await getMapController?.getCameraPosition()));
    }).onError((error) {
      Log.e("CameraStream Error: $error");
    });
  }

  void test() async {
    final locationOverlay = getMapController?.getLocationOverlay();
    Log.f(locationOverlay?.info.type);
    List<Placemark> placemark = await placemarkFromCoordinates(
        _position.value!.latitude, _position.value!.longitude);
    Log.f(
      '${placemark[0]}, ${placemark[0].subLocality}, ${placemark[0].thoroughfare}',
    );
    NMarker marker1 = NMarker(
      id: '1',
      position: NLatLng(_position.value!.latitude, _position.value!.longitude),
    );
    NCircleOverlay circle = NCircleOverlay(
      id: '2',
      center: NLatLng(_position.value!.latitude, _position.value!.longitude),
      radius: 300,
      color: Colors.black26,
      outlineWidth: 2,
    );
    if (getMapController != null) {
      await getMapController?.addOverlay(circle);
      await getMapController?.addOverlay(marker1);
    }
  }
}
