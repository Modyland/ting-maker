import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ting_maker/controller/chatting_controller.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/controller/myinfo_controller.dart';
import 'package:ting_maker/controller/myplace_controller.dart';
import 'package:ting_maker/database/db.dart';
import 'package:ting_maker/init.dart';
import 'package:ting_maker/middleware/binding_builder.dart';
import 'package:ting_maker/middleware/router_middleware.dart';
import 'package:ting_maker/model/person.dart';
import 'package:ting_maker/screen/account/find/find_success.dart';
import 'package:ting_maker/screen/account/find/password_change.dart';
import 'package:ting_maker/screen/account/login.dart';
import 'package:ting_maker/screen/home.dart';
import 'package:ting_maker/screen/main/community/community_notice_single.dart';
import 'package:ting_maker/screen/main/community/community_regi.dart';
import 'package:ting_maker/screen/main/community/community_view.dart';
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
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/widget/common_style.dart';

// const BasicMessageChannel<String> appLifeCycleChannel =
// BasicMessageChannel<String>('appLifeCycle', StringCodec());
late SqliteBase sqliteBase;
late PackageInfo packageInfo;
late Map<String, dynamic> deviceInfo;

final service = Get.find<MainProvider>();
var personBox = Hive.box<Person>('person');
var utilBox = Hive.box('util');
var searchBox = Hive.box('search');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static double height = Get.height;
  static double width = Get.width;
  static const normalErrorMsg = '잠시 후 다시 이용해 주세요.';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isLogin = utilBox.get('isLogin') ?? false;
    final person = personBox.get('person');
    final Map<String, dynamic> requestData = {'id': '', 'activity': ''};
    if (isLogin && person != null) {
      requestData['id'] = person.id;
      if (state == AppLifecycleState.resumed) {
        requestData['activity'] = 'login';
        service.loginLog(requestData);
        Log.e('Front');
      }
      if (state == AppLifecycleState.detached ||
          state == AppLifecycleState.paused) {
        requestData['activity'] = 'logout';
        service.loginLog(requestData);
        Log.e("Back");
      }
    }
  }

  String initRoute() {
    final isLogin = utilBox.get('isLogin') ?? false;
    final person = personBox.get('person');
    if (isLogin && person != null) {
      return '/home';
    } else {
      return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GlowingOverscrollIndicator(
        showLeading: false,
        showTrailing: false,
        axisDirection: AxisDirection.down,
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: GetMaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context),
              child: child!,
            ),
            scrollBehavior: NoGlowScrollBehavior(),
            debugShowCheckedModeBanner: false,
            // showPerformanceOverlay: true,
            enableLog: true,
            locale: Get.locale,
            supportedLocales: const [
              Locale('ko', 'KR'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            defaultTransition: Transition.native,
            transitionDuration: Durations.short4,
            title: 'Ting',
            theme: ThemeData(
              useMaterial3: false,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              splashColor: pointColor.withAlpha(30),
              highlightColor: pointColor.withAlpha(30),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                shadowColor: Colors.white,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                elevation: 10,
              ),
              bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.white,
              ),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: grey400,
                selectionColor: grey300,
                selectionHandleColor: grey300,
              ),
            ),
            initialBinding: BindingsBuilder(() {
              Get.put(MainProvider());
              Get.lazyPut(() => NavigationProvider());
              Get.lazyPut(() => CustomNaverMapController());
              Get.lazyPut(() => CommunityController());
              Get.lazyPut(() => MyInfoController());
              Get.lazyPut(() => MyPlaceController());
              Get.lazyPut(() => ChattingController());
            }),
            navigatorKey: Get.key,
            navigatorObservers: [RouterObserver()],
            initialRoute: initRoute(),
            getPages: [
              GetPage(
                name: '/',
                page: () => const OnboardingScreen(),
              ),
              GetPage(
                name: '/home',
                page: () => const MainScreen(),
                children: [
                  GetPage(
                    name: '/community_view',
                    page: () => const CommunityViewScreen(),
                    binding: CommunityViewBinding(),
                    transition: Transition.zoom,
                  ),
                  GetPage(
                    name: '/community_regi',
                    page: () => const CommunityRegiScreen(),
                    binding: CommunityRegiBinding(),
                    transition: Transition.zoom,
                  ),
                  GetPage(
                    name: '/community_notice',
                    page: () => const CommunityNoticeSingleScreen(),
                    binding: CommunityNoticeSingleBinding(),
                    transition: Transition.zoom,
                  ),
                ],
              ),
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
                name: '/find_success',
                page: () => const FindSuccessScreen(),
              ),
              GetPage(
                name: '/password_change',
                page: () => const PasswordChangeScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
