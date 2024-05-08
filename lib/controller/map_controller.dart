import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ting_maker/main.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/model/cluster.dart';
import 'package:ting_maker/model/user_model.dart';
import 'package:ting_maker/util/hole.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/widget/common_style.dart';

class CustomNaverMapController extends GetxController {
  final Rx<NaverMapController?> _mapController = Rx<NaverMapController?>(null);
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final Rx<Position?> _updatePosition = Rx<Position?>(null);
  final Rx<int?> _currentZoom = Rx<int?>(null);
  final Rx<StreamSubscription<Position>?> _positionStream =
      Rx<StreamSubscription<Position>?>(null);
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
    getPositionStream?.cancel();
    getMapController?.dispose();
    stopPositionTimer();
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
      Log.e(data);
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
  int? get getCurrentZoom => _currentZoom.value;
  String get getReverseGeocoding => reverseGeocoding.value;

  set setMapController(NaverMapController? controller) =>
      _mapController.value = controller;

  Map<String, dynamic> requestUserData() {
    final user = pref.getString('user');
    final userData = json.decode(user!);
    final UserModel userModel = UserModel.fromJson(userData);
    final Map<String, dynamic> userPositionData = {
      'clientId': socketId.value,
      'aka': userModel.aka,
      'userIdx': userModel.idx,
      'userId': userModel.id,
      'position': {}
    };
    return userPositionData;
  }

  void startPositionTimer() {
    final req = requestUserData();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      req['position'] = {
        'latitude': getCurrentPosition?.latitude,
        'longitude': getCurrentPosition?.longitude
      };
      socket.emit('requestUserPositionData', req);
    });
  }

  void stopPositionTimer() {
    _timer?.cancel();
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

  void stopPositionStream() async {
    await getPositionStream?.cancel();
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

  Future<void> getGeocoding() async {
    final GetConnect connect = GetConnect();
    final String stringLngLat =
        '${getCurrentPosition!.longitude},${getCurrentPosition!.latitude}';
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
        reverseGeocoding(stringGeocoding);
      }
    }
  }

  Future<void> getPolygonData() async {
    try {
      final res = await service.xyLocation();
      final data = res.body as List<dynamic>;

      for (var element in data) {
        final pName = element['kor_nm'];
        List<NLatLng> locationList = [];
        for (var location in element['location']) {
          locationList
              .add(NLatLng(location['latitude'], location['longitude']));
        }
        final mainPolygon = MainPolygon(pName, locationList);
        mainPolygons.add(mainPolygon);
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> initCurrentPosition() async {
    await locationPermissionCheck();

    // 현재 위치 가져오기
    final position = await Geolocator.getCurrentPosition();
    _currentPosition(position);
    _updatePosition(position);
  }

  Future<void> initPolygon() async {
    if (mainPolygons.isEmpty) {
      await getPolygonData();
    }
    const List<Map> supportList = [
      {
        'name': '양양',
        'holes': [firstHole, secondHole],
      },
    ];
    Set<NPolygonOverlay> overlays = {};
    for (var poly in mainPolygons) {
      bool support = false;
      Iterable<NLatLng>? supportHole;
      for (var supportItem in supportList) {
        if ((supportItem['name'] as String).contains(poly.name)) {
          supportHole = supportItem['holes'];
          support = true;
          break;
        }
      }
      final over = NPolygonOverlay(
        id: poly.name,
        coords: poly.location,
        color: Colors.black26,
        outlineColor: pointColor,
        outlineWidth: 1,
        holes: support ? [supportHole!] : [],
      );
      overlays.add(over);
    }
    await getMapController?.addOverlayAll(overlays);
  }

  Future<void> onMapReady() async {
    await getGeocoding();
    // await initPolygon();
    startPositionTimer();
    startPositionStream();
    if (getCurrentZoom != null) {
      await zoomChange(getCurrentZoom!);
    }
  }

  Future<void> onCameraIdle() async {
    final NCameraPosition cameraData =
        await getMapController!.getCameraPosition();
    int newZoom = cameraData.zoom.round();
    if (getCurrentZoom != newZoom) {
      _currentZoom(cameraData.zoom.round());
      await zoomChange(getCurrentZoom!);
    }
  }

  Future<void> getCurrentPositionCamera() async {
    await getMapController?.updateCamera(
      NCameraUpdate.withParams(
        target: NLatLng(
          getCurrentPosition!.latitude,
          getCurrentPosition!.longitude,
        ),
      ),
    );
  }

  Future<void> zoomChange(int zoomLevel) async {
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
      await getMapController?.clearOverlays(type: NOverlayType.marker);
      await getMapController?.addOverlayAll(markers);
    }
  }

  double calculateClusterRadius(num zoomLevel) {
    return 2 * pow(2, 21 - zoomLevel).toDouble();
  }

  Future<Set<NMarker>> clusterMarkers(
      Set<NMarker> markers, num zoomLevel) async {
    double clusterRadius = calculateClusterRadius(zoomLevel);
    List<Cluster> clusters = [];

    for (var marker in markers) {
      bool addedToCluster = false;
      for (var cluster in clusters) {
        final fLatLng =
            NLatLng(marker.position.latitude, marker.position.longitude);
        final cLatLng = cluster.averageLocation;
        final distance = fLatLng.distanceTo(cLatLng);

        if (distance < clusterRadius) {
          cluster.addMarker(marker);
          addedToCluster = true;
          break;
        }
      }

      if (!addedToCluster) {
        clusters.add(Cluster(
          marker.position.latitude,
          marker.position.longitude,
          {marker},
        ));
      }
    }
    Set<NMarker> clusteredMarkers = {};
    for (var cluster in clusters) {
      if (cluster.markers.length == 1) {
        clusteredMarkers.add(cluster.markers.first);
      } else {
        final double size = (26 + cluster.count).toDouble();
        final clusterIcon = await NOverlayImage.fromWidget(
          widget: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              border: Border.all(width: 1.5, color: pointColor),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                '+${cluster.count}',
                style: TextStyle(color: pointColor, fontSize: 16),
              ),
            ),
          ),
          size: Size(size, size),
          context: Get.context!,
        );
        NMarker clusterMarker = NMarker(
          id: 'cluster_${cluster.markers.first.info.id}',
          position: cluster.averageLocation,
          icon: clusterIcon,
        );
        clusteredMarkers.add(clusterMarker);
      }
    }

    return clusteredMarkers;
  }
}
