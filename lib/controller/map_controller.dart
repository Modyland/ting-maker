import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ting_maker/function/map_func.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/model/cluster.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/service/service.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/widget/cluster_custom.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/dialog/profile_dialog.dart';
import 'package:ting_maker/widget/marker_img.dart';
import 'package:ting_maker/widget/sheet/profile_sheet.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class CustomNaverMapController extends GetxController {
  static CustomNaverMapController get to => Get.find();
  final Rx<NaverMapController?> _mapController = Rx<NaverMapController?>(null);
  final Rx<StreamSubscription<Position>?> _positionStream =
      Rx<StreamSubscription<Position>?>(null);
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final Rx<Position?> _updatePosition = Rx<Position?>(null);
  final Rx<double?> _currentZoom = Rx<double?>(null);
  final Rx<List<dynamic>> _users = Rx<List<dynamic>>([]);
  final Rx<List<NMarker>> _markers = Rx<List<NMarker>>([]);
  final Rx<String> reverseGeocoding = '유성구 관평동'.obs;
  final Rx<String> socketId = ''.obs;
  final Rx<int> visible = Rx<int>(personBox.get('person')!.visible);

  final Rx<bool> isLoading = Rx<bool>(true);

  NaverMapController? get getMapController => _mapController.value;
  Position? get getCurrentPosition => _currentPosition.value;
  Position? get getUpdatePosition => _updatePosition.value;
  double? get getCurrentZoom => _currentZoom.value;
  List<dynamic> get getUsers => _users.value;
  List<NMarker> get getMarkers => _markers.value;
  int get getVisible => visible.value;
  StreamSubscription<Position>? get getPositionStream => _positionStream.value;
  String get getReverseGeocoding => reverseGeocoding.value;
  bool get getIsLoading => isLoading.value;
  set setMapController(NaverMapController? controller) =>
      _mapController(controller);
  set setVisible(int v) => visible(v);

  IO.Socket socket = IO.io(
    MainProvider.base,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setReconnectionDelay(5)
        .setReconnectionDelayMax(10)
        .setReconnectionAttempts(999)
        .build(),
  );

  @override
  void onInit() {
    super.onInit();
    initCurrentPosition();
    socketInit();
  }

  @override
  void onClose() {
    stopPositionStream();
    getMapController?.dispose();
    super.onClose();
  }

  Map<String, dynamic> requestUserData() {
    final Map<String, dynamic> userPositionData = {
      'clientId': socketId.value,
      'aka': NavigationProvider.to.getPerson.aka,
      'userIdx': NavigationProvider.to.getPerson.idx,
      'userId': NavigationProvider.to.getPerson.id,
      'position': {},
      'visible': getVisible,
    };
    return userPositionData;
  }

  Future<void> cameraStopSendData(List<NLatLng> region) async {
    final req = {
      'mapRect': [
        {'lat': region[0].latitude, 'lng': region[0].longitude},
        {'lat': region[1].latitude, 'lng': region[1].longitude},
        {'lat': region[2].latitude, 'lng': region[2].longitude},
        {'lat': region[3].latitude, 'lng': region[3].longitude}
      ],
      'visible': getVisible
    };
    socket.emit('requestUserPositionData', req);
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

  void socketInit() {
    socket.onConnect((_) async {
      Log.f('connect');
    });
    socket.onDisconnect((_) {
      Log.e('disconnect');
    });
    socket.on('join', (data) {
      socketId(data);
    });
    socket.on('UserPositionData', (data) async {
      await checkUsers(data);
    });
    socket.connect();
  }

  void startPositionStream() {
    // 현재 위치 스트림 연결
    _positionStream.value = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(),
    ).listen((Position position) {
      _currentPosition(position);
      if (NavigationProvider.to.currentIndex.value ==
          Navigation.naverMap.index) {
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

  void stopPositionStream() async {
    Log.i('포지션 스트림 종료');
    await getPositionStream?.cancel();
  }

  Future<void> visibleUpdate() async {
    try {
      final req = {
        'id': NavigationProvider.to.getPerson.id,
        'visible': visible.value == 1 ? 0 : 1
      };
      final res = await service.visibleUpdater(req);
      final data = json.decode(res.bodyString!);
      if (data) {
        setVisible = getVisible == 1 ? 0 : 1;
        NavigationProvider.to.person.value.visible = getVisible;
        await personBox.put('person', NavigationProvider.to.getPerson);
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    }

    final region = await nowCameraRegion();
    await cameraStopSendData(region);
  }

  Future<void> checkUsers(List<dynamic> data) async {
    Set<dynamic> currentUsers = getUsers.toSet();
    Set<dynamic> newData = data.toSet();

    final retainedUsers = currentUsers
        .where((cu) => newData.any((nd) => nd['userIdx'] == cu['userIdx']))
        .toSet();
    final addedUsers = newData
        .where(
            (nd) => !currentUsers.any((cu) => cu['userIdx'] == nd['userIdx']))
        .toList();

    _users.value = retainedUsers.union(addedUsers.toSet()).toList();

    _users.value.add({
      'clientId ': NavigationProvider.to.getPerson.id,
      'aka': NavigationProvider.to.getPerson.aka,
      'userIdx': NavigationProvider.to.getPerson.idx,
      'position': {
        'lat': getCurrentPosition?.latitude,
        'lng': getCurrentPosition?.longitude,
      },
      'visible': 1
    });
    final zoom = await nowCameraZoom();
    await zoomChange(zoom);
  }

  Future<void> initCurrentPosition() async {
    // 현재 위치 가져오기
    await locationPermissionCheck();
    final position = await Geolocator.getCurrentPosition();
    _currentPosition(position);
    _updatePosition(position);
  }

  Future<double> nowCameraZoom() async {
    // 현재 카메라 줌
    final cameraData = await getMapController!.getCameraPosition();
    return cameraData.zoom;
  }

  Future<List<NLatLng>> nowCameraRegion() async {
    // 현재 카메라 반경
    final region = await getMapController!.getContentRegion();
    return region;
  }

  Future<void> onMapReady() async {
    // final nGeocoding = await getGeocoding(position: getCurrentPosition);
    // if (nGeocoding != null) {
    //   reverseGeocoding(nGeocoding);
    //   Log.e(getReverseGeocoding);
    // }
    try {
      startPositionStream();
      final overlays = await initPolygon();
      await getMapController?.addOverlayAll(overlays);
    } catch (err) {
      Log.e('지도 뜨기전에 나감 : $err');
    }
  }

  Future<void> onCameraIdle() async {
    if (getMapController != null &&
        socket.connected &&
        NavigationProvider.to.currentIndex.value == Navigation.naverMap.index) {
      log('카메라 멈췄다!', time: DateTime.now(), name: 'camera');

      final region = await nowCameraRegion();
      await cameraStopSendData(region);
    }
  }

  Future<void> zoomChange(double zoomLevel) async {
    try {
      Set<NMarker> markers = {};
      if (getUsers.isNotEmpty) {
        List<Future<NMarker>> markerFutures =
            getUsers.map((u) => createMarker(u)).toList();
        markers.addAll(await Future.wait(markerFutures));
      }
      await clusterMarkers(markers, zoomLevel);
    } catch (err) {
      Log.e('줌 체인지 에러 : $err');
    }
  }

  Future<ImageInfo> fetchUserImage(int userIdx) async {
    final image = markerImg(userIdx);

    final Completer<ImageInfo> completer = Completer();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) {
        completer.complete(info);
      }),
    );

    return completer.future;
  }

  Future<NMarker> createMarker(dynamic user) async {
    const double size = 36;

    final ImageInfo imageInfo = await fetchUserImage(user['userIdx']);

    // 이미지 로드가 완료된 후에 마커를 생성합니다.
    final userIcon = await NOverlayImage.fromWidget(
      widget: SizedBox(
        width: size,
        height: size + 3,
        child: CustomPaint(
          painter: ClusterPainter(
            borderColor: NavigationProvider.to.getPerson.idx == user['userIdx']
                ? Colors.blueAccent.shade400
                : pointColor,
            backgroundColor: Colors.white,
            borderWidth: 2,
            imageInfo: imageInfo,
          ),
        ),
      ),
      size: const Size(size, size + 3),
      context: Get.context!,
    );
    return NMarker(
      id: NavigationProvider.to.getPerson.idx == user['userIdx']
          ? 'iam'
          : '${user['userIdx']}',
      icon: userIcon,
      position: NLatLng(
        user['position']['lat'],
        user['position']['lng'],
      ),
    )..setOnTapListener(
        (overlay) async {
          await showProfileDialog(user['userIdx'].toString());
        },
      );
  }

  Future<void> clusterMarkers(Set<NMarker> markers, double zoomLevel) async {
    num clusterRadius = await compute(calculateClusterRadius, zoomLevel);
    List<Cluster> clusters = [];
    if (markers.isNotEmpty) {
      Map<NLatLng, NMarker> latLngToMarker = {
        for (var marker in markers)
          NLatLng(marker.position.latitude, marker.position.longitude): marker
      };

      for (var entry in latLngToMarker.entries) {
        bool addedToCluster = false;
        // 'iam' ID를 가진 마커는 직접 추가
        if (entry.value.info.id == 'iam') {
          clusters.add(Cluster(
            entry.key.latitude,
            entry.key.longitude,
            {entry.value},
            [entry.value.info.id],
          ));
          continue;
        }
        for (var cluster in clusters) {
          final distance = entry.key.distanceTo(cluster.averageLocation);
          if (distance < clusterRadius) {
            cluster.addMarker(entry.value, entry.value.info.id);
            addedToCluster = true;
            break;
          }
        }
        if (!addedToCluster) {
          clusters.add(Cluster(
            entry.key.latitude,
            entry.key.longitude,
            {entry.value},
            [entry.value.info.id],
          ));
        }
      }
    }
    await createClusterMarkers(clusters);
  }

  Future<void> createClusterMarkers(List<Cluster> clusters) async {
    Set<NMarker> clusteredMarkers = {};

    if (clusters.isNotEmpty) {
      for (var cluster in clusters) {
        if (cluster.markers.length == 1) {
          clusteredMarkers.add(cluster.markers.first);
        } else {
          final double size = (36 + cluster.count).toDouble();
          NOverlayImage clusterIcon = await NOverlayImage.fromWidget(
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
                    '+${cluster.count}',
                    style:
                        TextStyle(color: pointColor, fontSize: 16, height: 0.9),
                  ),
                ),
              ),
            ),
            size: Size(size, size + 3),
            context: Get.context!,
          );
          NMarker clusterMarker = NMarker(
            id: 'cluster_${cluster.markers.first.info.id}_${cluster.count}',
            position: cluster.averageLocation,
            icon: clusterIcon,
          )..setOnTapListener(
              (overlay) async {
                await showProfileSheet(getUsers, cluster);
              },
            );
          clusteredMarkers.add(clusterMarker);
        }
      }
    }
    await showMarkers(clusteredMarkers);
  }

  Future<void> showMarkers(Set<NMarker> markers) async {
    try {
      if (getMapController != null) {
        await getMapController?.clearOverlays(type: NOverlayType.marker);
        await getMapController?.addOverlayAll(markers);
        await getMapController?.forceRefresh();
        if (getIsLoading) {
          Future.delayed(Durations.short4, () => isLoading(false));
        }
        // Set<NMarker> currentMarkers = getMarkers.toSet();
        // Set<NMarker> newData = markers.toSet();
        // final retainedMarkers = currentMarkers
        //     .where((cm) => newData.any((nd) => nd.info.id == cm.info.id))
        //     .toSet();
        // final addedMarkers = newData
        //     .where(
        //         (nd) => !currentMarkers.any((cm) => cm.info.id == nd.info.id))
        //     .toList();
        // await getMapController?.addOverlayAll(addedMarkers.toSet());
        // final removedMarkers = currentMarkers
        //     .where((cm) => !newData.any((nd) => nd.info.id == cm.info.id))
        //     .toList();
        // _markers.value = retainedMarkers.union(addedMarkers.toSet()).toList();
        // for (var marker in removedMarkers) {
        //   await getMapController?.deleteOverlay(marker.info);
        // }
      }
    } catch (err) {
      Log.e('지도 뜨기전에 나감 : $err');
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

  Future<void> moveFirstHole() async {
    await getMapController?.updateCamera(
      NCameraUpdate.withParams(
        target: const NLatLng(
          37.9699574603738,
          128.7609243929731,
        ),
      ),
    );
  }

  Future<void> moveSecondHole() async {
    await getMapController?.updateCamera(
      NCameraUpdate.withParams(
        target: const NLatLng(
          38.02553078143484,
          128.72203907865918,
        ),
      ),
    );
  }
}
