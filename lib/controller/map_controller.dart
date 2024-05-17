import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ting_maker/function/map_func.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/widget/cluster_custom.dart';
import 'package:ting_maker/widget/common_style.dart';

class CustomNaverMapController extends GetxController {
  final NavigationProvider navigationProvider = Get.find<NavigationProvider>();
  final Rx<NaverMapController?> _mapController = Rx<NaverMapController?>(null);
  final Rx<StreamSubscription<Position>?> _positionStream =
      Rx<StreamSubscription<Position>?>(null);
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final Rx<Position?> _updatePosition = Rx<Position?>(null);
  final Rx<double?> _currentZoom = Rx<double?>(null);
  final Rx<bool> _cameraState = true.obs;
  final StreamController<List<dynamic>> _usersController =
      StreamController.broadcast();
  final Rx<List<dynamic>> _users = Rx<List<dynamic>>([]);

  final Rx<String> reverseGeocoding = ''.obs;
  final Rx<String> socketId = ''.obs;

  // void startCameraTimer() {
  //   // 카메라 스트림 연결
  //   _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
  //     if (navigationProvider.currentIndex.value == Navigation.naverMap.index) {
  //       final cameraData = await nowCameraData();
  //       cameraStopSendData(cameraData, cameraData.zoom);
  //     }
  //   });
  // }

  // void stopCameraTimer() {
  //   Log.i('카메라 스트림 종료');
  //   _timer?.cancel();
  // }

  // 매번 값이 변경될 때 마다 호출 (반응 상태일때만 가능)
  // 한번만 호출
  // once(_currentPosition, (_) => print("한번만 호출"));
  // 이벤트가 끝났을때 실행
  // debounce(_currentPosition, (_) => print("마지막 변경에 한번만 호출"),
  // time: const Duration(seconds: 1));
  // 변경되고 있는 동안 설정한 초마다 실행
  // interval(_currentPosition, (_) => print("변경되고 있는 동안 1초마다 호출"),
  // time: const Duration(seconds: 1));

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
    stopPositionStream();
    stopUsersStream();
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
    socket.on('UserPositionData', (data) async {
      if (_users.value.isEmpty) {
        _users(data);
      } else {
        await checkUsers(data);
      }
    });
    socket.connect();
  }

  NaverMapController? get getMapController => _mapController.value;
  Position? get getCurrentPosition => _currentPosition.value;
  Position? get getUpdatePosition => _updatePosition.value;
  double? get getCurrentZoom => _currentZoom.value;
  bool get getCameraState => _cameraState.value;
  List<dynamic> get getUsers => _users.value;

  StreamSubscription<Position>? get getPositionStream => _positionStream.value;
  Stream<List<dynamic>> get usersStream => _usersController.stream;

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

  Future<void> checkUsers(List<dynamic> data) async {
    _users.value.retainWhere((item) => data.contains(item));

    final newData = data.where((item) => !_users.value.contains(item)).toList();
    if (newData.isNotEmpty) {
      _users.value.addAll(newData);
      _usersController.sink.add(_users.value);
    }
  }

  void startPositionStream() {
    // 현재 위치 스트림 연결
    _positionStream.value = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(),
    ).listen((Position position) {
      _currentPosition(position);
      if (navigationProvider.currentIndex.value == Navigation.naverMap.index) {
        final nowLatLng = NLatLng(position.latitude, position.longitude);
        final prevLatLng =
            NLatLng(getUpdatePosition!.latitude, getUpdatePosition!.longitude);
        final distance = prevLatLng.distanceTo(nowLatLng);
        if (distance > 3) {
          positionUpdate(position);
        }
      }
    });
  }

  void startUsersStream() {
    usersStream.listen((List<dynamic> event) async {
      final cameraData = await nowCameraData();
      final newZoom = cameraData.zoom;
      await zoomChange(newZoom);
    });
  }

  void stopPositionStream() async {
    Log.i('포지션 스트림 종료');
    await getPositionStream?.cancel();
  }

  void stopUsersStream() async {
    Log.i('유저 스트림 종료');
    await _usersController.close();
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
    // final nGeocoding = await getGeocoding(position: getCurrentPosition);
    // if (nGeocoding != null) {
    //   reverseGeocoding(nGeocoding);
    //   Log.e(getReverseGeocoding);
    // }
    try {
      startPositionStream();
      startUsersStream();
      final overlays = await initPolygon();
      await getMapController?.addOverlayAll(overlays);
    } catch (err) {
      Log.e('지도 뜨기전에 나감 : $err');
    }
  }

  Timer? _throttleTimer;

  Future<void> onCameraIdle() async {
    if (_throttleTimer?.isActive ?? false) return;

    _throttleTimer = Timer(const Duration(milliseconds: 500), () async {
      if (getMapController != null &&
          navigationProvider.currentIndex.value == Navigation.naverMap.index) {
        Log.f('카메라 데이터');
        setCameraState = true;
        final cameraData = await nowCameraData();
        final newZoom = cameraData.zoom;
        cameraStopSendData(cameraData, newZoom);
      }
    });
  }

  Future<void> zoomChange(double zoomLevel) async {
    Set<NMarker> markers = {};

    //   final testIcon = await NOverlayImage.fromWidget(
    //   widget: const FlutterLogo(),
    //   size: const Size(24, 24),
    //   context: Get.context!,
    // );

    for (var u in getUsers) {
      final double size = 24.toDouble();
      final userIcon = await NOverlayImage.fromWidget(
        widget: SizedBox(
          width: size,
          height: size + 3,
          child: CustomPaint(
            painter: ClusterPainter(
              borderColor: pointColor,
              backgroundColor: Colors.white,
              borderWidth: 2,
            ),
            child: Center(
              child: Text(
                '+${u['aka']}',
                style: TextStyle(color: pointColor, fontSize: 16, height: 0.9),
              ),
            ),
          ),
        ),
        size: Size(size, size + 3),
        context: Get.context!,
      );
      NMarker marker = NMarker(
        id: '${u['userIdx']}',
        icon: userIcon,
        position: NLatLng(
          u['position']['latitude'],
          u['position']['longitude'],
        ),
      )..setOnTapListener((overlay) async {
          Log.t(overlay);
        });
      markers.add(marker);
    }

    Log.e(markers);

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
