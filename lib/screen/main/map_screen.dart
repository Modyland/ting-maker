import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/map_controller.dart';

class NaverMapScreen extends GetView<CustomNaverMapController> {
  const NaverMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                minZoom: 8,
                //zoom 10부터 축제 묶기
                //zoom 12부터 사람 풀어서보여주기?
                maxZoom: 17,
                indoorEnable: true,
                indoorFocusRadius: 30,
                scaleBarEnable: false,
                logoAlign: NLogoAlign.rightTop,
              ),
              onMapReady: (nController) {
                controller.setMapController = nController;
                controller.test();
                controller.getSocket.emit('requestUserPositionData', 'test');
                controller.getSocket.emit('requestTest', '1');
              },
              onMapTapped: (point, latLng) {},
              onSymbolTapped: (symbol) {},
              onCameraChange: (position, reason) {
                controller.getCameraStream.sink.add(position);
              },
              onCameraIdle: () {},
              onSelectedIndoorChanged: (indoor) {},
            ),
            FloatingActionButton(onPressed: () {}),
          ],
        );
      }
    });
  }
}
