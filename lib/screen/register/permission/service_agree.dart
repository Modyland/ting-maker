import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class ServiceAgreeScreen extends StatefulWidget {
  const ServiceAgreeScreen({super.key});

  @override
  State<ServiceAgreeScreen> createState() => _ServiceAgreeScreenState();
}

Map<Permission, PermissionStatus>? permissions;

class _ServiceAgreeScreenState extends State<ServiceAgreeScreen> {
  bool allCheck = false;
  bool serviceAgree = false;
  bool infoAgree = false;
  bool infoAgree2 = false;
  bool locationAgree = false;
  bool marketingAgree = false;
  bool isNext = false;

  @override
  void initState() {
    super.initState();
  }

  void _checkCallback(bool selected) {
    setState(() {
      allCheck = selected;
      serviceAgree = selected;
      infoAgree = selected;
      infoAgree2 = selected;
      locationAgree = selected;
      marketingAgree = selected;
    });
    setState(() {
      isNext = serviceAgree && infoAgree && infoAgree2 && locationAgree;
    });
  }

  void _serviceCheck(bool selected) {
    setState(() {
      serviceAgree = selected;
    });
    _allCheckCheck();
  }

  void _infoCheck(bool selected) {
    setState(() {
      infoAgree = selected;
    });
    _allCheckCheck();
  }

  void _infoCheck2(bool selected) {
    setState(() {
      infoAgree2 = selected;
    });
    _allCheckCheck();
  }

  void _locationCheck(bool selected) {
    setState(() {
      locationAgree = selected;
    });
    _allCheckCheck();
  }

  void _marketingCheck(bool selected) {
    setState(() {
      marketingAgree = selected;
    });
    _allCheckCheck();
  }

  void _allCheckCheck() {
    setState(() {
      allCheck = serviceAgree &&
          infoAgree &&
          infoAgree2 &&
          locationAgree &&
          marketingAgree;
    });
    setState(() {
      isNext = serviceAgree && infoAgree && infoAgree2 && locationAgree;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\tTING', style: registerTitleStyle),
            Text('\t서비스 이용약관', style: registerTitleStyle),
            SizedBox(height: MyApp.height * 0.03),
            allCheckRow(allCheck, (selected) => _checkCallback(selected)),
            SizedBox(height: MyApp.height * 0.03),
            const Divider(),
            SizedBox(height: MyApp.height * 0.03),
            oneCheckRow(serviceAgree, '팅 서비스 이용약관 동의(필수)',
                (selected) => _serviceCheck(selected), () {}),
            oneCheckRow(infoAgree, '개인정보 수집 및 이용 동의(필수)',
                (selected) => _infoCheck(selected), () {}),
            oneCheckRow(infoAgree2, '개인정보 제3자 제공 동의(필수)',
                (selected) => _infoCheck2(selected), () {}),
            oneCheckRow(locationAgree, '위치기반 서비스 이용약관 동의(필수)',
                (selected) => _locationCheck(selected), () {}),
            oneCheckRow(marketingAgree, '마케팅 수신에 동의(선택)',
                (selected) => _marketingCheck(selected), () {}),
            const Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: MyApp.height * 0.04),
              width: double.infinity,
              height: 52,
              decoration: isNext ? enableButton : disableButton,
              child: MaterialButton(
                animationDuration: Durations.short4,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  isNext ? Get.toNamed('/permission') : null;
                },
                child: Center(
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 16,
                      color: isNext
                          ? const Color(0xffffffff)
                          : const Color(0xff9FA3AB),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
