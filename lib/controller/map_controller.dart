import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
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
import 'package:ting_maker/model/cluster.dart';
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
  final Rx<List<dynamic>> _users = Rx<List<dynamic>>([]);
  final Rx<String> reverseGeocoding = ''.obs;
  final Rx<String> socketId = ''.obs;

  NaverMapController? get getMapController => _mapController.value;
  Position? get getCurrentPosition => _currentPosition.value;
  Position? get getUpdatePosition => _updatePosition.value;
  double? get getCurrentZoom => _currentZoom.value;
  List<dynamic> get getUsers => _users.value;
  StreamSubscription<Position>? get getPositionStream => _positionStream.value;
  String get getReverseGeocoding => reverseGeocoding.value;
  set setMapController(NaverMapController? controller) =>
      _mapController(controller);

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
    getMapController?.dispose();
    super.onClose();
  }

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

  void cameraStopSendData(List<NLatLng> region) {
    final req = {
      'mapRect': [
        {'lat': region[0].latitude, 'lng': region[0].longitude},
        {'lat': region[1].latitude, 'lng': region[1].longitude},
        {'lat': region[2].latitude, 'lng': region[2].longitude},
        {'lat': region[3].latitude, 'lng': region[3].longitude}
      ]
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

  void stopPositionStream() async {
    Log.i('포지션 스트림 종료');
    await getPositionStream?.cancel();
  }

  Future<void> checkUsers(List<dynamic> data) async {
    if (getUsers.isEmpty) {
      for (var d in data) {
        final imageStream = await fetchUserImage(d['userIdx']);
        ImageStreamListener? listener;
        listener = ImageStreamListener((ImageInfo info, bool _) {
          d['profile'] = info;
          imageStream.removeListener(listener!);
        });
        imageStream.addListener(listener);
        _users.value.add(d);
      }
    } else {
      Set<dynamic> currentUsers = getUsers.toSet();
      Set<dynamic> newData = data.toSet();

      final retainedUsers = currentUsers
          .where((cu) => newData.any((nd) => nd['userIdx'] == cu['userIdx']))
          .toSet();
      final addedUsers = newData
          .where(
              (nd) => !currentUsers.any((cu) => cu['userIdx'] == nd['userIdx']))
          .toList();

      for (var user in addedUsers) {
        final imageStream = await fetchUserImage(user['userIdx']);
        ImageStreamListener? listener;
        listener = ImageStreamListener((ImageInfo info, bool _) {
          user['profile'] = info;
          imageStream.removeListener(listener!);
        });
        imageStream.addListener(listener);
      }

      _users.value = retainedUsers.union(addedUsers.toSet()).toList();
    }
    final zoom = await nowCameraZoom();
    zoomChange(zoom);
  }

  Future<ImageStream> fetchUserImage(int userIdx) async {
    String imageUrl =
        "http://db.medsyslab.co.kr:4500/ting/mapProfiles?idx=$userIdx";
    return ExtendedImage.network(
      imageUrl,
      cache: true,
      cacheKey: userIdx.toString(),
      cacheMaxAge: const Duration(days: 3),
      enableMemoryCache: true,
    ).image.resolve(ImageConfiguration.empty);
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

  // Timer? _throttleTimer;

  void onCameraIdle() async {
    if (getMapController != null &&
        navigationProvider.currentIndex.value == Navigation.naverMap.index) {
      Log.f('카메라 멈췄다!');

      final region = await nowCameraRegion();
      cameraStopSendData(region);
    }
    // _throttleTimer?.cancel();

    // _throttleTimer = Timer(const Duration(milliseconds: 300), () async {
    //   if (getMapController != null &&
    //       navigationProvider.currentIndex.value == Navigation.naverMap.index) {
    //     Log.f('카메라 멈췄다!');

    //     final region = await nowCameraRegion();
    //     cameraStopSendData(region);
    //   }
    // });
  }

  Future<void> zoomChange(double zoomLevel) async {
    try {
      Set<NMarker> markers = {};
      if (getUsers.isNotEmpty) {
        List<Future<NMarker>> markerFutures =
            getUsers.map((u) => createMarker(u)).toList();
        markers.addAll(await Future.wait(markerFutures));
        await clusterMarkers(markers, zoomLevel);
      }
    } catch (err) {
      Log.e('줌 체인지 에러 : $err');
    }
  }

  Future<NMarker> createMarker(dynamic user) async {
    const double size = 36;

    final userIcon = await NOverlayImage.fromWidget(
      widget: SizedBox(
        width: size,
        height: size + 3,
        child: CustomPaint(
          painter: ClusterPainter(
            borderColor: pointColor,
            backgroundColor: Colors.white,
            borderWidth: 2,
            imageInfo: user['profile'],
          ),
        ),
      ),
      size: const Size(size, size + 3),
      context: Get.context!,
    );
    return NMarker(
      id: '${user['userIdx']}',
      icon: userIcon,
      position: NLatLng(
        user['position']['lat'],
        user['position']['lng'],
      ),
    )..setOnTapListener((overlay) async {
        Log.t('${user['userIdx']}');
      });
  }

  Future<void> clusterMarkers(
    Set<NMarker> markers,
    double zoomLevel,
  ) async {
    num clusterRadius = await compute(calculateClusterRadius, zoomLevel);
    List<Cluster> clusters = [];
    if (markers.isNotEmpty) {
      Map<NLatLng, NMarker> latLngToMarker = {
        for (var marker in markers)
          NLatLng(marker.position.latitude, marker.position.longitude): marker
      };

      for (var entry in latLngToMarker.entries) {
        bool addedToCluster = false;
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
            id: 'cluster_${cluster.markers.first.info.id}',
            position: cluster.averageLocation,
            icon: clusterIcon,
          )..setOnTapListener((overlay) async {
              Log.t(cluster.userIdxs);
            });
          clusteredMarkers.add(clusterMarker);
        }
      }
    }
    await showMarkers(clusteredMarkers);
  }

  Future<void> showMarkers(Set<NMarker> markers) async {
    if (getMapController != null && markers.isNotEmpty) {
      try {
        await getMapController?.clearOverlays(type: NOverlayType.marker);
        await getMapController?.addOverlayAll(markers);
        // Log.e(DateTime.now().toLocal().toString());
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

  Future<void> mapRefresh() async {
    await getMapController?.forceRefresh();
  }
}
