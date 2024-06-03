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
  NLatLng(37.974520031172574, 128.76027235733585),
  NLatLng(37.97472872517569, 128.7583654872858),
  NLatLng(37.97211691104626, 128.75832592514416),
  NLatLng(37.97093164113558, 128.75807005511356),
  NLatLng(37.97021667524491, 128.75768885872927),
  NLatLng(37.969432386628654, 128.75712394864044),
  NLatLng(37.968966840888, 128.7569307821672),
  NLatLng(37.96867935754949, 128.75687841240122),
  NLatLng(37.96819376201295, 128.75682132079376),
  NLatLng(37.968130216540494, 128.75685394333263),
  NLatLng(37.96774214766333, 128.75690158820723),
  NLatLng(37.96738024435217, 128.75700675117895),
  NLatLng(37.96706234671384, 128.75718123571477),
  NLatLng(37.96671641368297, 128.7574233235064),
  NLatLng(37.96631474953523, 128.75777786804775),
  NLatLng(37.96606583090646, 128.75815880963026),
  NLatLng(37.965740617898696, 128.7588223960566),
  NLatLng(37.96545395927565, 128.75991928593777),
  NLatLng(37.96527228562159, 128.7612234906427),
  NLatLng(37.96520306058356, 128.76283760009773),
  NLatLng(37.964640790311705, 128.7636889214237),
  NLatLng(37.96431063693726, 128.76407926870922),
  NLatLng(37.96448775438044, 128.76548306309928),
  NLatLng(37.9652209628338, 128.76464722823064),
  NLatLng(37.96582498482648, 128.7646161739171),
  NLatLng(37.96655600536812, 128.763325110404),
  NLatLng(37.96805749759066, 128.76291724912605),
  NLatLng(37.9688659073718, 128.76307313602808),
  NLatLng(37.96909083473176, 128.76489350134366),
  NLatLng(37.969416291694806, 128.76601646270623),
  NLatLng(37.97122972317583, 128.76583232771935),
  NLatLng(37.97282835507858, 128.76375399356547),
  NLatLng(37.972564068382404, 128.76215450273347),
  NLatLng(37.974449097427225, 128.76019669251738),
  NLatLng(37.974520031172574, 128.76027235733585),
];

// 서피비치
const secondHole = [
  NLatLng(38.032355953214356, 128.71559867623753),
  NLatLng(38.03030858593125, 128.71268094433097),
  NLatLng(38.02058122294323, 128.72734897369418),
  NLatLng(38.023022444114325, 128.73041262773208),
];
