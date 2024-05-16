import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ting_maker/main.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/util/map_util.dart';

class CustomNaverMapController extends GetxController {
  final Rx<NaverMapController?> _mapController = Rx<NaverMapController?>(null);
  final Rx<StreamSubscription<Position>?> _positionStream =
      Rx<StreamSubscription<Position>?>(null);
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final Rx<Position?> _updatePosition = Rx<Position?>(null);
  final Rx<double?> _currentZoom = Rx<double?>(null);
  final Rx<bool> _cameraState = true.obs;
  final Rx<String> reverseGeocoding = ''.obs;
  final Rx<String> socketId = ''.obs;

  Timer? _timer;

  IO.Socket socket = IO.io(
      dotenv.get('TEST_SOCKET'),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  @override
  void onInit() {
    super.onInit();
    initCurrentPosition();
    socketInit();
  }

  @override
  void onClose() {
    stopCameraTimer();
    stopPositionStream();
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
    socket.on('join', (data) {
      socketId(data);
    });
    socket.on('UserPositionData', (data) {
      Log.e(data);
    });

    socket.connect();
  }

  NaverMapController? get getMapController => _mapController.value;
  StreamSubscription<Position>? get getPositionStream => _positionStream.value;
  Position? get getCurrentPosition => _currentPosition.value;
  Position? get getUpdatePosition => _updatePosition.value;
  double? get getCurrentZoom => _currentZoom.value;
  bool get getCameraState => _cameraState.value;
  String get getReverseGeocoding => reverseGeocoding.value;

  set setMapController(NaverMapController? controller) =>
      _mapController(controller);
  set setCameraState(bool state) => _cameraState(state);

  Map<String, dynamic> requestUserData() {
    final person = personBox.get('person');
    final Map<String, dynamic> userPositionData = {
      'clientId': socketId.value,
      'aka': person?.aka,
      'userIdx': person?.idx,
      'userId': person?.id,
      'position': {}
    };
    return userPositionData;
  }

  void startCameraTimer() {
    // 카메라 스트림 연결
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      final cameraData = await nowCameraData();
      cameraStopSendData(cameraData, cameraData.zoom);
    });
  }

  void startPositionStream() {
    // 현재 위치 스트림 연결
    _positionStream.value = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(),
    ).listen((Position position) {
      _currentPosition(position);
      final nowLatLng = NLatLng(position.latitude, position.longitude);
      final prevLatLng =
          NLatLng(getUpdatePosition!.latitude, getUpdatePosition!.longitude);
      final distance = prevLatLng.distanceTo(nowLatLng);
      if (distance > 2) {
        positionUpdate(position);
      }
    });
  }

  void stopCameraTimer() {
    Log.i('카메라 스트림 종료');
    _timer?.cancel();
  }

  void stopPositionStream() async {
    Log.i('포지션 스트림 종료');
    await getPositionStream?.cancel();
  }

  void cameraStopSendData(NCameraPosition cameraData, double zoomLevel) {
    final req = {
      'latitude': cameraData.target.latitude,
      'longitude': cameraData.target.longitude,
      'zoomLevel': zoomLevel
    };
    if (getCameraState) {
      socket.emit('requestUserPositionData', req);
    }
  }

  void positionUpdate(Position position) {
    final req = requestUserData();
    _updatePosition(position);
    req['position'] = {
      'latitude': position.latitude,
      'longitude': position.longitude
    };
    socket.emit('requestUpdate ', req);
  }

  Future<void> initCurrentPosition() async {
    // 현재 위치 가져오기
    await locationPermissionCheck();
    final position = await Geolocator.getCurrentPosition();
    _currentPosition(position);
    _updatePosition(position);
  }

  Future<NCameraPosition> nowCameraData() async {
    // 현재 카메라 데이터
    final cameraData = await getMapController!.getCameraPosition();
    return cameraData;
  }

  Future<void> onMapReady() async {
    try {
      startCameraTimer();
      startPositionStream();
      final overlays = await initPolygon();
      final cameraData = await nowCameraData();
      await getMapController?.addOverlayAll(overlays);
      await zoomChange(cameraData.zoom);
      // final nGeocoding = await getGeocoding(position: getCurrentPosition);
      // if (nGeocoding != null) {
      //   reverseGeocoding(nGeocoding);
      //   Log.e(getReverseGeocoding);
      // }
    } catch (err) {
      Log.e('지도 뜨기전에 나감 : $err');
    }
  }

  Future<void> onCameraIdle() async {
    setCameraState = true;
    final cameraData = await nowCameraData();
    final newZoom = cameraData.zoom;
    cameraStopSendData(cameraData, newZoom);
    if (getCurrentZoom != newZoom) {
      _currentZoom(newZoom);
      await zoomChange(newZoom);
    }
  }

  Future<void> zoomChange(double zoomLevel) async {
    const test1 = 0.0000115;
    const test2 = 0.0004212;
    const test3 = 0.0000320;
    const test4 = 0.0000430;

    final testIcon = await NOverlayImage.fromWidget(
      widget: const FlutterLogo(),
      size: const Size(24, 24),
      context: Get.context!,
    );

    NMarker marker1 = NMarker(
      id: '1',
      position: NLatLng(
        getCurrentPosition!.latitude + test1,
        getCurrentPosition!.longitude + test2,
      ),
    )..setOnTapListener((overlay) async {
        //클릭이벤트
      });
    NMarker marker2 = NMarker(
      id: '2',
      position: NLatLng(
        getCurrentPosition!.latitude + test3,
        getCurrentPosition!.longitude + test4,
      ),
      icon: testIcon,
    );
    NMarker marker3 = NMarker(
      id: '3',
      position: NLatLng(
        getCurrentPosition!.latitude - test1,
        getCurrentPosition!.longitude - test2,
      ),
    );
    NMarker marker4 = NMarker(
      id: '4',
      position: NLatLng(
        getCurrentPosition!.latitude - test3,
        getCurrentPosition!.longitude - test4,
      ),
    );

    Set<NMarker> markers = {marker1, marker2, marker3, marker4};

    Set<NMarker> clusteredMarkers = await clusterMarkers(markers, zoomLevel);
    showMarkers(clusteredMarkers);
  }

  void showMarkers(Set<NMarker> markers) async {
    if (getMapController != null) {
      try {
        await getMapController?.clearOverlays(type: NOverlayType.marker);
        await getMapController?.addOverlayAll(markers);
      } catch (err) {
        Log.e('지도 뜨기전에 나감 : $err');
      }
    }
  }

  Future<void> moveCurrentPositionCamera() async {
    await getMapController?.updateCamera(
      NCameraUpdate.withParams(
        target: NLatLng(
          getCurrentPosition!.latitude,
          getCurrentPosition!.longitude,
        ),
      ),
    );
  }
}
