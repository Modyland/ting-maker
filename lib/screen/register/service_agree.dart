import 'package:flutter/material.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/input_style.dart';

class ServiceAgreeScreen extends StatefulWidget {
  const ServiceAgreeScreen({super.key});

  @override
  State<ServiceAgreeScreen> createState() => _ServiceAgreeScreenState();
}

class _ServiceAgreeScreenState extends State<ServiceAgreeScreen> {
  bool allCheck = false;
  bool serviceAgree = false;
  bool infoAgree = false;
  bool infoAgree2 = false;
  bool locationAgree = false;
  bool marketingAgree = false;

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
    if (serviceAgree &&
        infoAgree &&
        infoAgree2 &&
        locationAgree &&
        marketingAgree) {
      setState(() {
        allCheck = true;
      });
    } else {
      allCheck = false;
    }
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
            const SizedBox(height: 30),
            allCheckRow(allCheck, (selected) => _checkCallback(selected)),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            oneCheckRow(serviceAgree, '팅 서비스 이용약관 동의(필수)',
                (selected) => _serviceCheck(selected), () {}),
            oneCheckRow(infoAgree, '개인정보 수집 및 이용 동의(필수)',
                (selected) => _infoCheck(selected), () {}),
            oneCheckRow(infoAgree2, '개인정보 제3자 제공 동의(필수)',
                (selected) => _infoCheck2(selected), () {}),
            oneCheckRow(locationAgree, '위치기반 서비스 이용약관 동의(필수)',
                (selected) => _locationCheck(selected), () {}),
            oneCheckRow(marketingAgree, '마게팅 수신에 동의(선택)',
                (selected) => _marketingCheck(selected), () {}),
            const Spacer(),
            ElevatedButton(onPressed: () {}, child: const Text('123')),
          ],
        ),
      ),
    );
  }
}
