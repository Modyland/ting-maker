import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/screen/register/phone_check.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class PhoneCheckScreen2 extends StatefulWidget {
  const PhoneCheckScreen2({
    super.key,
  });

  @override
  State<PhoneCheckScreen2> createState() => _PhoneCheckScreen2State();
}

class _PhoneCheckScreen2State extends State<PhoneCheckScreen2> {
  Map<String, dynamic> registerData = Get.arguments;
  final GlobalKey<FormState> _phoneFormKey2 = GlobalKey<FormState>();
  final TextEditingController _phoneCheckEditing2 = TextEditingController();

  late Timer _timer;
  Duration _remainingTime = const Duration(minutes: 3);
  String formattedTime = '00:00';

  bool isNext = false;
  int validCheck = 0;

  @override
  void initState() {
    super.initState();
    threeMinuteTimer();
  }

  void threeMinuteTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
          formattedTime =
              '${_remainingTime.inMinutes.toString().padLeft(2, '0')}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}';
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void phoneCheckCallback() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final res = await service.phoneCheck2(
      registerData['phone'],
      _phoneCheckEditing2.text,
    );
    if (res.body is Map<String, dynamic> && res.body.containsKey('msg')) {
      // 인증시간 만료
      validCheck = 1;
      _phoneFormKey2.currentState!.validate();
    } else {
      final data = json.decode(res.body);
      if (data) {
        Get.toNamed('/register', arguments: {'phone': registerData['phone']});
      } else {
        //인증번호 틀림
        validCheck = 0;
        _phoneFormKey2.currentState!.validate();
      }
    }
  }

  @override
  void dispose() {
    _phoneCheckEditing2.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\t인증번호를 입력해주세요.', style: registerTitleStyle),
                  const SizedBox(height: 10),
                  const Text(
                    '\t\t문자 메세지를 통해 발송된 인증번호를 입력해주세요.',
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _phoneFormKey2,
                    child: TextFormField(
                      autofocus: true,
                      autofillHints: const <String>[AutofillHints.oneTimeCode],
                      controller: _phoneCheckEditing2,
                      decoration: inputDecoration('000000'),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onChanged: (value) {
                        setState(() {
                          isNext = value.length == 6;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '인증번호를 입력해주세요';
                        } else if (validCheck == 0) {
                          return '인증번호를 확인해주세요';
                        } else if (validCheck == 1) {
                          return '인증시간이 만료되었습니다.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Text(
                    '남은 시간 $formattedTime',
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: '인증 문자가 오지 않나요?',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
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
                        isNext ? phoneCheckCallback() : null;
                      },
                      child: Center(
                        child: Text(
                          '인증 확인',
                          style: TextStyle(
                            fontSize: 16,
                            color: isNext ? Colors.white : grey400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
