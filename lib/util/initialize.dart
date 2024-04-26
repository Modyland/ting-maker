import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ting_maker/firebase_options.dart';
import 'package:ting_maker/main.dart';
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
  pref = await SharedPreferences.getInstance();
  sqliteBase = SqliteBase();
  await NaverMapSdk.instance.initialize(clientId: dotenv.get('NAVER_KEY'));
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
  Log.t('Initialized Default App ${app.name}');
}
