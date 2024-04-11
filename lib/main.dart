import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ting_maker/controller/sample_controller.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/screen/home.dart';
import 'package:ting_maker/screen/login.dart';
import 'package:ting_maker/screen/onboarding.dart';
import 'package:ting_maker/screen/register.dart';

late SharedPreferences pref;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  unawaited(init());
  runApp(const MyApp());
}

Future<void> init() async {
  await dotenv.load();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static double height = Get.height;
  static double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context),
          child: child!,
        ),
        enableLog: true,
        defaultTransition: Transition.leftToRightWithFade,
        transitionDuration: Durations.short4,
        title: 'Ting',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialBinding: BindingsBuilder(() {
          Get.lazyPut<SampleController>(() => SampleController(), fenix: true);
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
          GetPage(name: '/register', page: () => const RegisterScreen()),
          GetPage(name: '/login', page: () => const LoginScreen()),
        ],
      ),
    );
  }
}
