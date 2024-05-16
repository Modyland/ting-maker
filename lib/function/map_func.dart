import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/cluster.dart';
import 'package:ting_maker/widget/cluster_custom.dart';
import 'package:ting_maker/widget/common_style.dart';

Future<String?> getGeocoding({Position? position}) async {
  final GetConnect connect = GetConnect();
  final String stringLngLat = '${position!.longitude},${position.latitude}';
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
      return stringGeocoding;
    }
  }
  return null;
}

Future<Set<NPolygonOverlay>> initPolygon() async {
  Set<NPolygonOverlay> overlays = {};
  for (var poly in polygons) {
    List<NLatLng> coords = [];
    List<List<NLatLng>> holes = [];
    for (var p in poly.location) {
      coords.add(NLatLng(p.latitude, p.longitude));
    }
    for (var supportItem in supportList) {
      if (supportItem['sigCode'] == poly.key) {
        holes = supportItem['holes'];
        break;
      }
    }
    NPolygonOverlay overlay = NPolygonOverlay(
      id: poly.key,
      coords: coords,
      color: Colors.black26,
      outlineColor: pointColor,
      outlineWidth: 2,
      holes: holes.isNotEmpty ? holes : [],
    );
    overlays.add(overlay);
  }
  return overlays;
}

Future<Set<NMarker>> clusterMarkers(
    Set<NMarker> markers, double zoomLevel) async {
  num clusterRadius = calculateClusterRadius(zoomLevel);
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
        marker.position.latitude,
        marker.position.longitude,
        {marker},
      ));
    }
  }
  Set<NMarker> clusteredMarkers = {};
  for (var cluster in clusters) {
    if (cluster.markers.length == 1) {
      clusteredMarkers.add(cluster.markers.first);
    } else {
      final double size = (26 + cluster.count).toDouble();
      final clusterIcon = await NOverlayImage.fromWidget(
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
                style: TextStyle(color: pointColor, fontSize: 16, height: 0.9),
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

double calculateClusterRadius(double zoomLevel) {
  return 1.5 * pow(2, 21 - zoomLevel).toDouble();
}

const List<Map> supportList = [
  {
    'sigCode': '51830_2',
    'holes': [firstHole, secondHole],
  },
];

// 인구해변
const firstHole = [
  NLatLng(37.974725931764894, 128.75764847471967),
  NLatLng(37.96559714859452, 128.7572714718079),
  NLatLng(37.96552724031009, 128.7643473366902),
  NLatLng(37.97436747622002, 128.76474106544796),
];

// 서피비치
const secondHole = [
  NLatLng(38.032355953214356, 128.71559867623753),
  NLatLng(38.03030858593125, 128.71268094433097),
  NLatLng(38.02058122294323, 128.72734897369418),
  NLatLng(38.023022444114325, 128.73041262773208),
];
