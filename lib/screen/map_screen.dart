import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/util/f_logger.dart';

class NaverMapScreen extends StatefulWidget {
  const NaverMapScreen({super.key});

  @override
  State<NaverMapScreen> createState() => _NaverMapScreenState();
}

CustomNaverMapController _customNaverMapController =
    Get.find<CustomNaverMapController>();

StreamSubscription<Position> _positionStream = Geolocator.getPositionStream(
  locationSettings: const LocationSettings(),
).listen((Position position) async {
  _customNaverMapController.setPosition = position;
  Log.e(position);
});

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('위치 꺼놨을때');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.openLocationSettings();
      return Future.error('위치 권한 거부');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openLocationSettings();
    return Future.error('영구적으로 거부');
  }

  final position = await Geolocator.getCurrentPosition();

  _customNaverMapController.setPosition = position;

  return position;
}

class _NaverMapScreenState extends State<NaverMapScreen>
    with AutomaticKeepAliveClientMixin {
  final StreamController<NCameraUpdateReason> _onCameraChangeStreamController =
      StreamController<NCameraUpdateReason>.broadcast();
  void test() async {
    final position = _customNaverMapController.getPosition;
    List<Placemark> placemark =
        await placemarkFromCoordinates(position!.latitude, position.longitude);
    Log.e(
      '${placemark[0].subLocality} , ${placemark[0].thoroughfare}',
    );
    NMarker marker1 = NMarker(
      id: '1',
      position: NLatLng(position.latitude, position.longitude),
    );
    NCircleOverlay circle = NCircleOverlay(
      id: '2',
      center: NLatLng(position.latitude, position.longitude),
    );
    if (_customNaverMapController.getMapController != null) {
      await _customNaverMapController.getMapController?.addOverlay(circle);
      await _customNaverMapController.getMapController?.addOverlay(marker1);
    }
  }

  void cameraChangeStream() {
    _onCameraChangeStreamController.stream.listen((reason) {
      Log.e(reason);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    cameraChangeStream();
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _onCameraChangeStreamController.close();
    _customNaverMapController.getMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        FutureBuilder(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NaverMap(
                options: NaverMapViewOptions(
                  locale: const Locale('ko'),
                  extent: const NLatLngBounds(
                    southWest: NLatLng(31.43, 122.37),
                    northEast: NLatLng(44.35, 132.0),
                  ),
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    ),
                    zoom: 16,
                    bearing: 0,
                    tilt: 0,
                  ),
                  activeLayerGroups: [
                    NLayerGroup.building,
                    NLayerGroup.bicycle,
                    NLayerGroup.transit,
                  ],
                  minZoom: 10,
                  indoorEnable: true,
                  logoAlign: NLogoAlign.rightTop,
                ),
                forceGesture: true,
                onMapReady: (controller) async {
                  _customNaverMapController.setMapController = controller;
                  // 현재 화면에 보이는 범위 가져오기
                  _customNaverMapController.getMapController
                      ?.getContentBounds();
                  test();
                },
                onMapTapped: (point, latLng) {},
                onSymbolTapped: (symbol) {},
                onCameraChange: (position, reason) {
                  _onCameraChangeStreamController.sink.add(position);
                },
                onCameraIdle: () {},
                onSelectedIndoorChanged: (indoor) {},
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        // 내가 직접 조작할 버튼 만들어야함
        FloatingActionButton(onPressed: () {}),
      ],
    );
  }
}
