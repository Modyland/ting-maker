import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geojson/geojson.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ting_maker/firebase_options.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/main_polygon.dart';
import 'package:ting_maker/model/person.dart';
import 'package:ting_maker/util/db.dart';
import 'package:ting_maker/util/device_info.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/util/map_util.dart';

Future<void> featuresFromAssetGeoJson(
  String assetPath, {
  String? nameProperty,
  bool verbose = false,
}) async {
  final featureCollection = GeoJsonFeatureCollection();
  final geojson = GeoJson();
  geojson.endSignal.listen((_) => geojson.dispose());
  try {
    final String geoJsonString = await rootBundle.loadString(assetPath);
    await geojson.parse(
      geoJsonString,
      nameProperty: nameProperty,
      verbose: verbose,
    );
  } catch (e) {
    rethrow;
  }
  for (var f in geojson.features) {
    featureCollection.collection.add(f);
  }
  for (var c in featureCollection.collection) {
    if (c.type == GeoJsonFeatureType.multipolygon) {
      for (int i = 0; i < c.geometry.polygons.length; i++) {
        print(i);
        for (var multi in c.geometry.polygons[i]) {
          print(multi.toLatLng());
          print(c.properties);
        }
      }
    }
    // else if (c.type == GeoJsonFeatureType.polygon) {
    //   print(c.geometry.geoSeries.first.toLatLng());
    //   print(c.properties);
    // }
  }
}

Future<void> initializeService() async {
  await initStorage();
  await featuresFromAssetGeoJson('assets/geojson/korea_converted.geojson');
  unawaited(initData());
  unawaited(initFirebase());
}

Future<void> initStorage() async {
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(MainPolygonAdapter());
  await dotenv.load();
  await Hive.initFlutter();
  await NaverMapSdk.instance.initialize(clientId: dotenv.get('NAVER_KEY'));
  await Hive.openBox<Person>('person');
  await Hive.openBox<MainPolygon>('polygons');
  await Hive.openBox('util');
  sqliteBase = SqliteBase();
}

Future<void> initData() async {
  await polygonBox.clear();
  await utilBox.clear();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await deviceData();
  packageInfo = await PackageInfo.fromPlatform();
}

Future<void> initFirebase() async {
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Log.f('Initialized Default App ${app.name}');
}
