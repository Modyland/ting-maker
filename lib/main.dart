import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/controller/profile_controller.dart';
import 'package:ting_maker/firebase_options.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/screen/account/find_id_pwd.dart';
import 'package:ting_maker/screen/account/login.dart';
import 'package:ting_maker/screen/home.dart';
import 'package:ting_maker/screen/onboarding/onboarding.dart';
import 'package:ting_maker/screen/register/permission/permission.dart';
import 'package:ting_maker/screen/register/permission/service_agree.dart';
import 'package:ting_maker/screen/register/phone_check.dart';
import 'package:ting_maker/screen/register/phone_check2.dart';
import 'package:ting_maker/screen/register/profile/image_crop.dart';
import 'package:ting_maker/screen/register/register.dart';
import 'package:ting_maker/screen/register/register2.dart';
import 'package:ting_maker/screen/register/register3.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/service/service.dart';
import 'package:ting_maker/util/device_info.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/widget/common_style.dart';

late SharedPreferences pref;
late PackageInfo packageInfo;
late Map<String, dynamic> deviceInfo;

final service = Get.find<MainProvider>();
const BasicMessageChannel<String> appLifeCycleChannel =
    BasicMessageChannel<String>('appLifeCycle', StringCodec());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await initStorage();
  unawaited(initData());
  unawaited(initFirebase());
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }
    Log.f('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'AWESOME SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

Future<void> initStorage() async {
  await dotenv.load();
  pref = await SharedPreferences.getInstance();
  await NaverMapSdk.instance.initialize(clientId: dotenv.get('NAVER_KEY'));
}

Future<void> initData() async {
  appLifeCycleChannel.setMessageHandler((message) async {
    if (message == "lifeCycleStateWithDetached") {
      final Map<String, dynamic> requestData = {'id': '', 'activity': 'logout'};
      service.loginLog(requestData);
      Log.e("앱이 종료되었습니다.");
    }
    return "Received";
  });
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static double height = Get.height;
  static double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: GetMaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context),
            child: child!,
          ),
          debugShowCheckedModeBanner: false,
          enableLog: true,
          locale: Get.locale,
          supportedLocales: const [
            Locale('ko', 'KR'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          defaultTransition: Transition.leftToRightWithFade,
          transitionDuration: Durations.short4,
          title: 'Ting',
          theme: ThemeData(
            useMaterial3: false,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: grey500,
              selectionColor: grey400,
              selectionHandleColor: grey400,
            ),
          ),
          initialBinding: BindingsBuilder(() {
            Get.put(NavigationProvider(), permanent: true);
            Get.put(ImageProfileController());
            Get.put(CustomNaverMapController(), permanent: true);
            Get.lazyPut<MainProvider>(() => MainProvider(), fenix: true);
          }),
          navigatorKey: Get.key,
          navigatorObservers: [RouterObserver()],
          initialRoute: '/',
          getPages: [
            GetPage(
                name: '/',
                page: () {
                  final isLogin = pref.getBool('isLogin') ?? false;
                  if (isLogin) {
                    return const MainScreen();
                  } else {
                    return const OnboardingScreen();
                  }
                }),
            GetPage(name: '/home', page: () => const MainScreen()),
            GetPage(
              name: '/service_agree',
              page: () => const ServiceAgreeScreen(),
            ),
            GetPage(
              name: '/permission',
              page: () => const PermissionScreen(),
            ),
            GetPage(
              name: '/phone_check',
              page: () => const PhoneCheckScreen(),
            ),
            GetPage(
              name: '/phone_check2',
              page: () => const PhoneCheckScreen2(),
            ),
            GetPage(
              name: '/register',
              page: () => const RegisterScreen(),
            ),
            GetPage(
              name: '/register2',
              page: () => const RegisterScreen2(),
            ),
            GetPage(
              name: '/register3',
              page: () => const RegisterScreen3(),
            ),
            GetPage(
              name: '/image_crop',
              page: () => const ImageCropScreen(),
            ),
            GetPage(
              name: '/login',
              page: () => const LoginScreen(),
            ),
            GetPage(
              name: '/find_id_pwd',
              page: () => const FindIdPwdScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
