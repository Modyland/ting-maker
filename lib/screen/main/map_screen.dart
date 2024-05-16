import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/util/logger.dart';

class NaverMapScreen extends GetView<CustomNaverMapController> {
  const NaverMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final currentPosition = controller.getCurrentPosition;
        if (currentPosition == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          const NLatLngBounds extentBounds = NLatLngBounds(
            southWest: NLatLng(31.43, 122.37),
            northEast: NLatLng(44.35, 132.0),
          );
          final NCameraPosition initCamera = NCameraPosition(
            target: NLatLng(
              currentPosition.latitude,
              currentPosition.longitude,
            ),
            zoom: 16,
          );
          return Stack(
            children: [
              NaverMap(
                options: NaverMapViewOptions(
                  locale: const Locale('ko'),
                  extent: extentBounds,
                  initialCameraPosition: initCamera,
                  activeLayerGroups: [
                    NLayerGroup.building,
                  ],
                  minZoom: 11,
                  maxZoom: 21,
                  zoomGesturesFriction: 0.3,
                  scrollGesturesFriction: 0.3,
                  rotationGesturesEnable: false,
                  indoorEnable: true,
                  scaleBarEnable: false,
                  locationButtonEnable: false,
                  logoAlign: NLogoAlign.leftBottom,
                ),
                onMapReady: (nController) async {
                  controller.setMapController = nController;
                  await controller.onMapReady();
                },
                onCameraChange: (reason, animated) {
                  controller.setCameraState = false;
                },
                onCameraIdle: () async {
                  await controller.onCameraIdle();
                },
                onMapTapped: (point, latLng) {
                  // 지도에서 클릭한 위치 나옴
                  Log.e(latLng);
                },
                onSymbolTapped: (symbol) {
                  // 지도 안에 정적인 심볼 클릭
                },
                onSelectedIndoorChanged: (indoor) {
                  // 실내 지도 층 변경시
                },
              ),
              FloatingActionButton(
                onPressed: () async {
                  await controller.moveCurrentPositionCamera();
                },
              ),
            ],
          );
        }
      },
    );
  }
}
