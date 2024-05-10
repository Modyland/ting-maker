import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:hive/hive.dart';

part 'main_polygon.g.dart';

@HiveType(typeId: 2)
class MainPolygon {
  @HiveField(0)
  String gisCode;
  @HiveField(1)
  List<NLatLng> location;

  MainPolygon({
    required this.gisCode,
    required this.location,
  });
}
