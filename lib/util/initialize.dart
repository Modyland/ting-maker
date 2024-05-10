import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ting_maker/firebase_options.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/main_polygon.dart';
import 'package:ting_maker/model/person.dart';
import 'package:ting_maker/util/db.dart';
import 'package:ting_maker/util/device_info.dart';
import 'package:ting_maker/util/logger.dart';

Future<void> initializeService() async {
  await initStorage();
  unawaited(initData());
  unawaited(initFirebase());
}

Future<void> initStorage() async {
  await dotenv.load();
  await Hive.initFlutter();
  await NaverMapSdk.instance.initialize(clientId: dotenv.get('NAVER_KEY'));
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(MainPolygonAdapter());
  sqliteBase = SqliteBase();
  await Hive.openBox<Person>('person');
  await Hive.openBox<MainPolygon>('polygons');
  await Hive.openBox('util');
}

Future<void> initData() async {
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
