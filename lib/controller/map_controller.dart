import 'dart:async';

import 'package:extended_image/extended_image.dart';
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
  final Rx<bool> _cameraState = true.obs;
  final StreamController<List<dynamic>> _usersController =
      StreamController.broadcast();
  final Rx<List<dynamic>> _users = Rx<List<dynamic>>([]);
  final Rx<List<Map<String, dynamic>>> _usersImage =
      Rx<List<Map<String, dynamic>>>([]);

  final Rx<String> reverseGeocoding = ''.obs;
  final Rx<String> socketId = ''.obs;

  NaverMapController? get getMapController => _mapController.value;
  Position? get getCurrentPosition => _currentPosition.value;
  Position? get getUpdatePosition => _updatePosition.value;
  double? get getCurrentZoom => _currentZoom.value;
  bool get getCameraState => _cameraState.value;
  List<dynamic> get getUsers => _users.value;
  List<Map<String, dynamic>> get getUsersImage => _usersImage.value;

  StreamSubscription<Position>? get getPositionStream => _positionStream.value;
  Stream<List<dynamic>> get usersStream => _usersController.stream;

  String get getReverseGeocoding => reverseGeocoding.value;

  set setMapController(NaverMapController? controller) =>
      _mapController(controller);
  set setCameraState(bool state) => _cameraState(state);

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
    stopUsersStream();
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

  Future<void> checkUsers(List<dynamic> data) async {
    final currentUsers = getUsers.toSet();
    final newData = data.toSet();
    Log.e(currentUsers);
    Log.e(newData);
    Log.e(currentUsers.isEmpty && newData.isNotEmpty);
    final retainedUsers = currentUsers.intersection(newData);
    final addedUsers = newData.difference(currentUsers);

    if (currentUsers.isEmpty && newData.isNotEmpty) {
      for (var user in newData) {
        final idx = '${user['userIdx']}';
        ImageProvider<Object> newUserImage = await fetchUserImage(idx);
        _usersImage.value
            .add({'idx': user['userIdx'], 'profile': newUserImage});
      }
    } else {
      if (addedUsers.isNotEmpty) {
        getUsers
          ..clear()
          ..addAll(retainedUsers)
          ..addAll(addedUsers);
        _usersController.sink.add(getUsers);
        for (var user in addedUsers) {
          final idx = '${user['userIdx']}';
          ImageProvider<Object> newUserImage = await fetchUserImage(idx);
          _usersImage.value
              .add({'idx': user['userIdx'], 'profile': newUserImage});
        }
      } else {
        _users.value.retainWhere((item) => retainedUsers.contains(item));
      }
    }
  }

  Future<ImageProvider<Object>> fetchUserImage(String userIdx) async {
    String imageUrl =
        "http://db.medsyslab.co.kr:4500/ting/mapProfiles?idx=$userIdx";
    return ExtendedImage.network(
      imageUrl,
      cache: true,
      cacheKey: userIdx,
      cacheMaxAge: const Duration(days: 3),
      enableMemoryCache: true,
    ).image;
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

  void startUsersStream() {
    usersStream.listen((List<dynamic> event) async {
      final cameraData = await nowCameraData();
      final newZoom = cameraData.zoom;
      await zoomChange(newZoom);
    });
  }

  void stopPositionStream() async {
    Log.i('포지션 스트림 종료');
    await getPositionStream?.cancel();
  }

  void stopUsersStream() async {
    Log.i('유저 스트림 종료');
    await _usersController.close();
  }

  void cameraStopSendData(NCameraPosition cameraData, double zoomLevel) {
    final req = {
      'latitude': cameraData.target.latitude,
      'longitude': cameraData.target.longitude,
      'zoomLevel': zoomLevel
    };
    if (getCameraState) {
      socket.emit('requestUserPositionData', req);
    }
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

  Future<void> initCurrentPosition() async {
    // 현재 위치 가져오기
    await locationPermissionCheck();
    final position = await Geolocator.getCurrentPosition();
    _currentPosition(position);
    _updatePosition(position);
  }

  Future<NCameraPosition> nowCameraData() async {
    // 현재 카메라 데이터
    final cameraData = await getMapController!.getCameraPosition();
    return cameraData;
  }

  Future<void> onMapReady() async {
    // final nGeocoding = await getGeocoding(position: getCurrentPosition);
    // if (nGeocoding != null) {
    //   reverseGeocoding(nGeocoding);
    //   Log.e(getReverseGeocoding);
    // }
    try {
      startPositionStream();
      startUsersStream();
      final overlays = await initPolygon();
      await getMapController?.addOverlayAll(overlays);
    } catch (err) {
      Log.e('지도 뜨기전에 나감 : $err');
    }
  }

  Timer? _throttleTimer;
  Future<void> onCameraIdle() async {
    _throttleTimer?.cancel();

    _throttleTimer = Timer(const Duration(milliseconds: 400), () async {
      if (getMapController != null &&
          navigationProvider.currentIndex.value == Navigation.naverMap.index) {
        Log.f('카메라 데이터');
        setCameraState = true;
        final cameraData = await nowCameraData();
        final newZoom = cameraData.zoom;
        cameraStopSendData(cameraData, newZoom);
      }
    });
  }

  Future<void> zoomChange(double zoomLevel) async {
    try {
      Set<NMarker> markers = {};
      List<Future<NMarker>> markerFutures =
          getUsers.map((u) => createMarker(u)).toList();
      markers.addAll(await Future.wait(markerFutures));

      final Set<NMarker> clusteredMarkers =
          await clusterMarkers(markers, zoomLevel);
      await showMarkers(clusteredMarkers);
    } catch (err) {
      Log.e('줌 체인지 에러 : $err');
    }
  }

  Future<NMarker> createMarker(dynamic user) async {
    const double size = 36;
    final Map<String, dynamic> userImage = getUsersImage.firstWhere(
      (img) => img['idx'] == user['userIdx'],
    );
    print(userImage);

    final userIcon = await NOverlayImage.fromWidget(
      widget: SizedBox(
        width: size,
        height: size + 3,
        child: CustomPaint(
          painter: ClusterPainter(
            borderColor: pointColor,
            backgroundColor: Colors.white,
            borderWidth: 2,
            image: userImage['profile'],
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
        user['position']['latitude'],
        user['position']['longitude'],
      ),
    )..setOnTapListener((overlay) async {
        Log.t(overlay);
      });
  }

  Future<Set<NMarker>> clusterMarkers(
    Set<NMarker> markers,
    double zoomLevel,
  ) async {
    num clusterRadius = calculateClusterRadius(zoomLevel);
    List<Cluster> clusters = [];

    Map<NLatLng, NMarker> latLngToMarker = {
      for (var marker in markers)
        NLatLng(marker.position.latitude, marker.position.longitude): marker
    };

    for (var entry in latLngToMarker.entries) {
      bool addedToCluster = false;
      for (var cluster in clusters) {
        final distance = entry.key.distanceTo(cluster.averageLocation);

        if (distance < clusterRadius) {
          cluster.addMarker(entry.value);
          addedToCluster = true;
          break;
        }
      }

      if (!addedToCluster) {
        clusters.add(Cluster(
          entry.key.latitude,
          entry.key.longitude,
          {entry.value},
        ));
      }
    }

    return await createClusterMarkers(clusters);
  }

  Future<Set<NMarker>> createClusterMarkers(List<Cluster> clusters) async {
    Set<NMarker> clusteredMarkers = {};
    Map<double, NOverlayImage> sizeToImageCache = {};

    for (var cluster in clusters) {
      if (cluster.markers.length == 1) {
        clusteredMarkers.add(cluster.markers.first);
      } else {
        final double size = (36 + cluster.count).toDouble();
        NOverlayImage clusterIcon =
            sizeToImageCache[size] ??= await NOverlayImage.fromWidget(
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
        );
        clusteredMarkers.add(clusterMarker);
      }
    }

    return clusteredMarkers;
  }

  Future<void> showMarkers(Set<NMarker> markers) async {
    if (getMapController != null) {
      try {
        await getMapController?.clearOverlays(type: NOverlayType.marker);
        await getMapController?.addOverlayAll(markers);
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
}
