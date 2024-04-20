import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ting_maker/util/f_logger.dart';

class NaverMapScreen extends StatefulWidget {
  const NaverMapScreen({super.key});

  @override
  State<NaverMapScreen> createState() => _HomeScreenState();
}

const LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 20,
);

StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
  print(position == null
      ? 'Unknown'
      : '${position.latitude.toString()}, ${position.longitude.toString()}');
});

NaverMapController? mapController;

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

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  List<Placemark> placemark =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  Log.e(placemark[0].country);

  return position;
}

NMarker? marker1;

void test() async {
  final data = await _determinePosition();
  marker1 = NMarker(id: '1', position: NLatLng(data.latitude, data.longitude));
  if (mapController != null) {
    await mapController!.addOverlay(marker1!);
  }

// final circle = NCircleOverlay(id: '1', center: latLng3);
}

class _HomeScreenState extends State<NaverMapScreen> {
  @override
  void initState() {
    _determinePosition().then((value) {
      test();
    });
    super.initState();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NaverMap(
              options: NaverMapViewOptions(
                locale: const Locale('ko'),
                locationButtonEnable: true,
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
                indoorEnable: true,
                activeLayerGroups: [
                  NLayerGroup.building,
                ],
                minZoom: 10,
                logoAlign: NLogoAlign.rightTop,
              ),
              forceGesture: true,
              onMapReady: (controller) {
                mapController = controller;
              },
              onMapTapped: (point, latLng) {},
              onSymbolTapped: (symbol) {},
              onCameraChange: (position, reason) {},
              onCameraIdle: () {},
              onSelectedIndoorChanged: (indoor) {},
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    ]);
  }
}
