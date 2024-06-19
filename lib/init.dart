import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ting_maker/database/db.dart';
import 'package:ting_maker/firebase_options.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/person.dart';
import 'package:ting_maker/util/device.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

// Future<void> initGeoJson(
//   String assetPath, {
//   String? nameProperty,
//   bool verbose = false,
// }) async {
//   final featureCollection = GeoJsonFeatureCollection();
//   final geojson = GeoJson();
//   geojson.endSignal.listen((_) => geojson.dispose());
//   try {
//     final String geoJsonString = await rootBundle.loadString(assetPath);
//     await geojson.parse(
//       geoJsonString,
//       nameProperty: nameProperty,
//       verbose: verbose,
//     );
//   } catch (e) {
//     rethrow;
//   }
//   for (var f in geojson.features) {
//     featureCollection.collection.add(f);
//   }
//   for (var c in featureCollection.collection) {
//     if (c.type == GeoJsonFeatureType.multipolygon) {
//       int idx = 1;
//       final sigCode = c.properties?['SIG_CD'];
//       final korName = c.properties?['SIG_KOR_NM'];
//       final multiPolygons = c.geometry as GeoJsonMultiPolygon;
//       for (var p in multiPolygons.polygons) {
//         for (var m in p.geoSeries) {
//           final key = '${sigCode}_$idx';
//           final location = m.toLatLng();
//           final poly = Polygon(
//             key: key,
//             sigCode: sigCode,
//             korName: korName,
//             location: location,
//           );
//           polygons.add(poly);
//           idx++;
//         }
//       }
//     } else if (c.type == GeoJsonFeatureType.polygon) {
//       final polygon = c.geometry as GeoJsonPolygon;
//       final sigCode = c.properties?['SIG_CD'];
//       final korName = c.properties?['SIG_KOR_NM'];
//       final key = '$sigCode';
//       final location = polygon.geoSeries.first.toLatLng();
//       final poly = Polygon(
//         key: key,
//         sigCode: sigCode,
//         korName: korName,
//         location: location,
//       );
//       polygons.add(poly);
//     }
//   }
// }

Future<void> initializeService() async {
  // await initGeoJson('assets/geojson/korea_converted.geojson');
  await initStorage();
  unawaited(initData());
  unawaited(initFirebase());
}

Future<void> initStorage() async {
  await dotenv.load();
  await NaverMapSdk.instance.initialize(clientId: dotenv.get('NAVER_KEY'));
  Hive.registerAdapter(PersonAdapter());
  await Hive.initFlutter();
  await Hive.openBox<Person>('person');
  await Hive.openBox('util');
  await Hive.openBox('search');
  sqliteBase = SqliteBase();
}

Future<void> initData() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  deviceInfo = await deviceData();
  packageInfo = await PackageInfo.fromPlatform();
  await getSubjectList();
}

Future<void> initFirebase() async {
  FirebaseApp app = await Firebase.initializeApp(
    name: 'tingproject11',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    // save token to server
  });
  if (Platform.isIOS) {
    String? fcmToken = await FirebaseMessaging.instance.getAPNSToken();
    Log.e(fcmToken);
  } else {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    Log.e(fcmToken);
  }

  Log.f('Initialized Default App ${app.name}');
}

Future<void> getSubjectList() async {
  try {
    int subjectLength = 0;
    final subject = utilBox.get('subject');
    if (subject != null) {
      subjectLength = subject.length;
    }
    final res = await service.getSubject(subjectLength);
    final data = json.decode(res.bodyString!) as List;
    if (data.isNotEmpty) {
      await utilBox.put('subject', data);
      log('${utilBox.get('subject')}', time: DateTime.now());
    }
  } catch (err) {
    log('$err', name: 'Subject');
    noTitleSnackbar(MyApp.normalErrorMsg);
  }
}
