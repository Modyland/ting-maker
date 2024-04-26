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

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   await pref.reload();
//   final log = pref.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await pref.setStringList('log', log);
//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         // flutterLocalNotificationsPlugin.show(
//         //   888,
//         //   'COOL SERVICE',
//         //   'Awesome ${DateTime.now()}',
//         //   const NotificationDetails(
//         //     android: AndroidNotificationDetails(
//         //       'my_foreground',
//         //       'MY FOREGROUND SERVICE',
//         //       icon: 'ic_bg_service_small',
//         //       ongoing: true,
//         //     ),
//         //   ),
//         // );
//       }
//     }
//     Log.f('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//   });
// }

Future<void> initializeService() async {
  await initStorage();
  unawaited(initData());
  unawaited(initFirebase());
  // final bgService = FlutterBackgroundService();
  // // const AndroidNotificationChannel channel = AndroidNotificationChannel(
  // //   'my_foreground',
  // //   'AWESOME SERVICE',
  // //   description: 'This channel is used for important notifications.',
  // //   importance: Importance.low,
  // // );
  // // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // //     FlutterLocalNotificationsPlugin();

  // // if (Platform.isIOS || Platform.isAndroid) {
  // //   await flutterLocalNotificationsPlugin.initialize(
  // //     const InitializationSettings(
  // //       iOS: DarwinInitializationSettings(),
  // //       android: AndroidInitializationSettings('ic_bg_service_small'),
  // //     ),
  // //   );
  // // }

  // // await flutterLocalNotificationsPlugin
  // //     .resolvePlatformSpecificImplementation<
  // //         AndroidFlutterLocalNotificationsPlugin>()
  // //     ?.createNotificationChannel(channel);
  // await bgService.configure(
  //   androidConfiguration: AndroidConfiguration(
  //     onStart: onStart,
  //     autoStart: true,
  //     isForegroundMode: false,
  //     // notificationChannelId: 'my_foreground',
  //     // initialNotificationTitle: 'AWESOME SERVICE',
  //     // initialNotificationContent: 'Initializing',
  //     // foregroundServiceNotificationId: 888,
  //   ),
  //   iosConfiguration: IosConfiguration(
  //     autoStart: true,
  //     onForeground: onStart,
  //     onBackground: onIosBackground,
  //   ),
  // );
}

Future<void> initStorage() async {
  await dotenv.load();
  pref = await SharedPreferences.getInstance();
  sqliteBase = SqliteBase();
  await NaverMapSdk.instance.initialize(clientId: dotenv.get('NAVER_KEY'));
}

Future<void> initData() async {
  // appLifeCycleChannel.setMessageHandler((message) async {
  //   if (message == "lifeCycleStateWithDetached") {
  //     final Map<String, dynamic> requestData = {'id': '', 'activity': 'logout'};
  //     service.loginLog(requestData);
  //     Log.e("Message Exit");
  //   }
  //   return "Received";
  // });
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
