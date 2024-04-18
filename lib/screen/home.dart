import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  //위치 받아오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          // initialCameraPosition: NCameraPosition(
          //     target: NLatLng(latitude, longitude),
          //     zoom: 10,
          //     bearing: 0,
          //     tilt: 0),
          indoorEnable: true,
          indoorFocusRadius: 30,
          activeLayerGroups: [
            NLayerGroup.building,
            // NLayerGroup.transit,
            // NLayerGroup.traffic
          ],
        ),
        onMapReady: (controller) {
          print("네이버 맵 로딩됨!");
        },
      ),
    );
  }
}
