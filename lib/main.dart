import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ting_maker/controller/sample_controller.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/screen/account/find_id_pwd.dart';
import 'package:ting_maker/screen/account/login.dart';
import 'package:ting_maker/screen/home.dart';
import 'package:ting_maker/screen/onboarding/onboarding.dart';
import 'package:ting_maker/screen/register/permission.dart';
import 'package:ting_maker/screen/register/phone_check.dart';
import 'package:ting_maker/screen/register/phone_check2.dart';
import 'package:ting_maker/screen/register/profile_create.dart';
import 'package:ting_maker/screen/register/register.dart';
import 'package:ting_maker/screen/register/register2.dart';
import 'package:ting_maker/screen/register/register3.dart';
import 'package:ting_maker/screen/register/service_agree.dart';
import 'package:ting_maker/service/sample_service.dart';
import 'package:ting_maker/util/device_info.dart';

late SharedPreferences pref;
late PackageInfo packageInfo;
late Map<String, dynamic> deviceInfo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await NaverMapSdk.instance.initialize(clientId: dotenv.get('NAVER_KEY'));
  pref = await SharedPreferences.getInstance();
  unawaited(init());
  runApp(const MyApp());
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
            Locale('ko', ''),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          defaultTransition: Transition.leftToRightWithFade,
          transitionDuration: Durations.short4,
          title: 'Ting',
          themeMode: ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.grey.shade600,
              selectionColor: Colors.grey.shade400,
              selectionHandleColor: Colors.grey.shade400,
            ),
          ),
          initialBinding: BindingsBuilder(() {
            Get.lazyPut<SampleProvider>(() => SampleProvider(), fenix: true);
            Get.lazyPut<SampleController>(() => SampleController(),
                fenix: true);
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
                    return const HomeScreen();
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
              name: '/profile_create',
              page: () => const ProfileCreateScreen(),
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
