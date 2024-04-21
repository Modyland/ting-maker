import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ting_maker/controller/map_controller.dart';
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

late SharedPreferences pref;
late PackageInfo packageInfo;
late Map<String, dynamic> deviceInfo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStorage();
  unawaited(init());
  unawaited(initFirebase());
  runApp(const MyApp());
}

Future<void> initStorage() async {
  await dotenv.load();
  pref = await SharedPreferences.getInstance();
  await NaverMapSdk.instance.initialize(clientId: dotenv.get('NAVER_KEY'));
}

Future<void> deviceData() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    deviceInfo = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  } else if (Platform.isIOS) {
    deviceInfo = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  } else if (kIsWeb) {
    deviceInfo = readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
  }
}

Future<void> init() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
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
              cursorColor: Colors.grey.shade600,
              selectionColor: Colors.grey.shade400,
              selectionHandleColor: Colors.grey.shade400,
            ),
          ),
          initialBinding: BindingsBuilder(() {
            Get.put(NavigationProvider(), permanent: true);
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
