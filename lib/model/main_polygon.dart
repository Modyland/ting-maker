import 'package:hive/hive.dart';

part 'main_polygon.g.dart';

@HiveType(typeId: 2)
class MainPolygon {
  @HiveField(0)
  int gisCode;
  @HiveField(1)
  List<dynamic> location;

  MainPolygon({
    required this.gisCode,
    required this.location,
  });
}
