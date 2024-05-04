import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/model/cluster.dart';
import 'package:ting_maker/util/toast.dart';
import 'package:ting_maker/widget/common_style.dart';

class CustomNaverMapController extends GetxController {
  final Rx<NaverMapController?> _mapController = Rx<NaverMapController?>(null);
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final Rx<int?> _currentZoom = Rx<int?>(null);
  final Rx<Position?> _position = Rx<Position?>(null);
  final Rxn<NCameraUpdateReason> _cameraReason = Rxn<NCameraUpdateReason>();
  final Rx<StreamSubscription<Position>?> _positionStream =
      Rx<StreamSubscription<Position>?>(null);
  final StreamController<NCameraUpdateReason> _cameraStream =
      StreamController<NCameraUpdateReason>.broadcast();

  final Rx<String> reverseGeocoding = Rx<String>('');

  // IO.Socket socket = IO.io(
  //     dotenv.get('TEST_SOCKET'),
  //     IO.OptionBuilder()
  //         .setTransports(['websocket'])
  //         .disableAutoConnect()
  //         .build());
  @override
  void onInit() {
    super.onInit();
    determinePosition();
    onCameraUpdate();
    // socketInit();
  }

  @override
  void onClose() {
    getPositionStream?.cancel();
    getCameraStream.close();
    getMapController?.dispose();
    super.onClose();
  }

  // void socketInit() {
  //   socket.onConnect((_) {
  //     Log.f('connect');
  //   });
  //   socket.onDisconnect((_) {
  //     Log.e('disconnect');
  //   });
  //   socket.on('test', (data) {
  //     Log.e(data);
  //   });
  //   socket.connect();
  // }

  NaverMapController? get getMapController => _mapController.value;
  StreamSubscription<Position>? get getPositionStream => _positionStream.value;
  StreamController<NCameraUpdateReason> get getCameraStream => _cameraStream;
  Position? get getCurrentPosition => _currentPosition.value;
  Position? get getPosition => _position.value;
  int? get getCurrentZoom => _currentZoom.value;

  // IO.Socket get getSocket => socket;

  String get getReverseGeocoding => reverseGeocoding.value;

  set setMapController(NaverMapController? controller) =>
      _mapController.value = controller;
  set setPosition(Position position) => _position.value = position;

  Future<void> determinePosition() async {
    await locationPermissionCheck();

    // 현재 위치 스트림 연결
    // _positionStream.value = Geolocator.getPositionStream(
    //   locationSettings: const LocationSettings(),
    // ).listen((Position position) async {
    //   setPosition = position;
    //   Log.f(position);
    // });

    // 현재 위치 가져오기
    final position = await Geolocator.getCurrentPosition();
    _currentPosition.value = position;
  }

  void onCameraUpdate() {
    // _cameraStream.stream.listen((NCameraUpdateReason reason) async {
    //   _cameraReason.value = reason;
    //   Log.e((await getMapController?.getCameraPosition()));
    // }).onError((error) {
    //   Log.e("CameraStream Error: $error");
    // });
  }

  void onCameraIdle() async {
    final NCameraPosition cameraData =
        await getMapController!.getCameraPosition();
    int newZoom = cameraData.zoom.round();
    if (getCurrentZoom != newZoom) {
      _currentZoom.value = cameraData.zoom.round();
      zoomChange(getCurrentZoom!);
    }
  }

  void getCurrentPositionCamera() async {
    await getMapController?.updateCamera(
      NCameraUpdate.withParams(
        target: NLatLng(_currentPosition.value!.latitude,
            _currentPosition.value!.longitude),
      ),
    );
  }

  Future<void> getGeocoding() async {
    final GetConnect connect = GetConnect();
    final String stringLngLat =
        '${_currentPosition.value!.longitude},${_currentPosition.value!.latitude}';
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

  void zoomChange(int zoomLevel) async {
    await getGeocoding();
    const test1 = 0.0000115;
    const test2 = 0.0004212;
    const test3 = 0.0000320;
    const test4 = 0.0000430;

    final iconImage = await NOverlayImage.fromWidget(
      widget: const FlutterLogo(),
      size: const Size(24, 24),
      context: Get.context!,
    );
    NMarker marker1 = NMarker(
      id: '1',
      position: NLatLng(
        _currentPosition.value!.latitude + test1,
        _currentPosition.value!.longitude + test2,
      ),
    )..setOnTapListener(
        (overlay) async => await normalToast(overlay.info.id, errColor));
    NMarker marker2 = NMarker(
      id: '2',
      position: NLatLng(_currentPosition.value!.latitude + test3,
          _currentPosition.value!.longitude + test4),
      icon: iconImage,
    );
    NMarker marker3 = NMarker(
      id: '3',
      position: NLatLng(_currentPosition.value!.latitude - test1,
          _currentPosition.value!.longitude - test2),
    );
    NMarker marker4 = NMarker(
      id: '4',
      position: NLatLng(_currentPosition.value!.latitude - test3,
          _currentPosition.value!.longitude - test4),
    );

    Set<NMarker> markers = {marker1, marker2, marker3, marker4};

    if (zoomLevel == 21) {
      showMarkers(markers);
    } else {
      Set<NMarker> clusteredMarkers = await clusterMarkers(markers, zoomLevel);
      showMarkers(clusteredMarkers);
    }
  }

  void showMarkers(Set<NMarker> markers) async {
    if (getMapController != null) {
      await getMapController?.clearOverlays();
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
            marker.position.latitude, marker.position.longitude, {marker}));
      }
    }
    Set<NMarker> clusteredMarkers = {};
    for (var cluster in clusters) {
      if (cluster.markers.length == 1) {
        clusteredMarkers.add(cluster.markers.first);
      } else {
        final double size = (24 + cluster.count).toDouble();
        final iconImage = await NOverlayImage.fromWidget(
          widget: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              border: Border.all(width: 1.5, color: pointColor),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                '+${cluster.count}',
                style: TextStyle(color: pointColor),
              ),
            ),
          ),
          size: Size(size, size),
          context: Get.context!,
        );
        NMarker clusterMarker = NMarker(
          id: 'cluster_${clusters.first.markers.first.info.id}',
          position: cluster.averageLocation,
          icon: iconImage,
        );
        clusteredMarkers.add(clusterMarker);
      }
    }

    return clusteredMarkers;
  }
}







 // 위경도 좌표를 화면 좌표로 변환할 수 있어요.
    // Future<NPoint> latLngToScreenLocation(NLatLng latLng);
    // const latLng = NLatLng(37.5666, 126.979);
    // const seoulStationLatLng = NLatLng(37.555759, 126.972939);
    // final distance = latLng.distanceTo(seoulStationLatLng);
    // Log.f(distance);

    // NCircleOverlay circle = NCircleOverlay(
    //   id: '2',
    //   center: NLatLng(_position.value!.latitude, _position.value!.longitude),
    //   radius: 300,
    //   color: Colors.black26,
    //   outlineWidth: 2,
    // );
    // final onMarkerInfoWindow =
    //     NInfoWindow.onMarker(id: marker1.info.id, text: "인포윈도우 텍스트");
    // marker1.openInfoWindow(onMarkerInfoWindow);
   