import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/map_controller.dart';

class NaverMapScreen extends GetView<CustomNaverMapController> {
  const NaverMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final position = controller.getCurrentPosition;
        if (position == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Stack(
            children: [
              NaverMap(
                options: NaverMapViewOptions(
                  locale: const Locale('ko'),
                  extent: const NLatLngBounds(
                    southWest: NLatLng(31.43, 122.37),
                    northEast: NLatLng(44.35, 132.0),
                  ),
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(
                      position.latitude,
                      position.longitude,
                    ),
                    zoom: 16,
                  ),
                  activeLayerGroups: [
                    NLayerGroup.building,
                  ],
                  minZoom: 12,
                  maxZoom: 21,
                  indoorEnable: true,
                  indoorFocusRadius: 30,
                  // scaleBarEnable: false,
                  logoAlign: NLogoAlign.rightTop,
                ),
                onMapReady: (nController) {
                  controller.setMapController = nController;
                },
                onMapTapped: (point, latLng) {
                  // 지도에서 클릭한 위치 나옴
                },
                onSymbolTapped: (symbol) {
                  // 지도 안에 정적인 심볼 클릭
                },
                onCameraChange: (position, reason) {
                  controller.getCameraStream.sink.add(position);
                },
                onCameraIdle: () {
                  controller.onCameraIdle();
                },
                onSelectedIndoorChanged: (indoor) {
                  // 실내 지도 층 변경시
                },
              ),
              FloatingActionButton(onPressed: () {
                controller.getCurrentPositionCamera();
              }),
            ],
          );
        }
      },
    );
  }
}
