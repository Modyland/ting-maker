import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_style.dart';

// Future<Set<NPolygonOverlay>> initPolygon() async {
//   Set<NPolygonOverlay> overlays = {};
//   for (var poly in polygons) {
//     List<NLatLng> coords = [];
//     List<List<NLatLng>> holes = [];
//     for (var p in poly.location) {
//       coords.add(NLatLng(p.latitude, p.longitude));
//     }
//     for (var supportItem in supportList) {
//       if (supportItem['sigCode'] == poly.key) {
//         holes = supportItem['holes'];
//         break;
//       }
//     }
//     NPolygonOverlay overlay = NPolygonOverlay(
//       id: poly.key,
//       coords: coords,
//       color: Colors.black26,
//       outlineColor: pointColor,
//       outlineWidth: 2,
//       holes: holes.isNotEmpty ? holes : [],
//     );
//     overlays.add(overlay);
//   }
//   return overlays;
// }

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
  NPolygonOverlay overlay = NPolygonOverlay(
    id: 'korea',
    coords: koreaOverlay,
    color: Colors.black26,
    outlineColor: pointColor,
    outlineWidth: 4,
    holes: [firstHole, secondHole],
  );
  Set<NPolygonOverlay> overlays = {overlay};
  return overlays;
}

double calculateClusterRadius(double zoomLevel) {
  return 1.5 * pow(2, 21 - zoomLevel).toDouble();
}

const koreaOverlay = [
  NLatLng(39.650663372158114, 121.95238022118342),
  NLatLng(39.650663372158114, 132.1747214835342),
  NLatLng(31.50282244262745, 132.1747214835342),
  NLatLng(31.50282244262745, 31.50282244262745),
  NLatLng(39.650663372158114, 121.95238022118342),
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
