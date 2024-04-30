import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
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

  final Rx<String> reverseGeocoding = Rx<String>('');

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

  String get getReverseGeocoding => reverseGeocoding.value;

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

  Future<void> getGeocoding() async {
    final GetConnect connect = GetConnect();
    final String stringLngLat =
        '${_position.value!.longitude},${_position.value!.latitude}';
    final res = await connect.get(
      'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$stringLngLat&sourcecrs=epsg:4326&output=json&orders=admcode',
      headers: {
        'X-NCP-APIGW-API-KEY-ID': dotenv.get('NAVER_KEY'),
        'X-NCP-APIGW-API-KEY': dotenv.get('NAVER_SECRET')
      },
      contentType: 'application/json',
    );
    if (res.statusCode == 200) {
      if (res.body != null) {
        final stringGeocoding =
            '${res.body['results'][0]['region']['area2']['name']} - ${res.body['results'][0]['region']['area3']['name']}';
        reverseGeocoding.value = stringGeocoding;
      }
    }
  }

  void test() async {
    await getGeocoding();

    // 위경도 좌표를 화면 좌표로 변환할 수 있어요.
    // Future<NPoint> latLngToScreenLocation(NLatLng latLng);

    NMarker marker1 = NMarker(
      id: '1',
      position: NLatLng(_position.value!.latitude, _position.value!.longitude),
    );
    const latLng = NLatLng(37.5666, 126.979);
    const seoulStationLatLng = NLatLng(37.555759, 126.972939);
    final distance = latLng.distanceTo(seoulStationLatLng);
    Log.f(distance);

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
    final onMarkerInfoWindow =
        NInfoWindow.onMarker(id: marker1.info.id, text: "인포윈도우 텍스트");
    marker1.openInfoWindow(onMarkerInfoWindow);
    marker1.setOnTapListener((mark) {
      mark.setPosition(NLatLng(_position.value!.latitude + 0.0000010,
          _position.value!.longitude + 0.0000010));
    });
  }
}
