import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ting_maker/controller/sample_controller.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/screen/account/find_id.dart';
import 'package:ting_maker/screen/account/find_pwd.dart';
import 'package:ting_maker/screen/account/login.dart';
import 'package:ting_maker/screen/home.dart';
import 'package:ting_maker/screen/onboarding/onboarding.dart';
import 'package:ting_maker/screen/register/phone_check.dart';
import 'package:ting_maker/screen/register/register.dart';
import 'package:ting_maker/screen/register/service_agree.dart';

late SharedPreferences pref;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  unawaited(init());
  runApp(const MyApp());
}

Future<void> init() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load();
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
          enableLog: true,
          defaultTransition: Transition.leftToRightWithFade,
          transitionDuration: Durations.short4,
          title: 'Ting',
          themeMode: ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: Colors.grey.shade600),
          ),
          initialBinding: BindingsBuilder(() {
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
                name: '/service_agree', page: () => const ServiceAgreeScreen()),
            GetPage(name: '/phone_check', page: () => const PhoneCheckScreen()),
            GetPage(name: '/register', page: () => const RegisterScreen()),
            GetPage(name: '/login', page: () => const LoginScreen()),
            GetPage(name: '/find_id', page: () => const FindIdScreen()),
            GetPage(name: '/find_pwd', page: () => const FindPwdScreen())
          ],
        ),
      ),
    );
  }
}
