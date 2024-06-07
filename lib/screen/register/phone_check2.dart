import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

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
  int validCheck = -1;

  @override
  void initState() {
    super.initState();
    threeMinuteTimer();
  }

  @override
  void dispose() {
    _phoneCheckEditing2.dispose();
    _timer.cancel();
    super.dispose();
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

  Future<void> phoneCheckCallback() async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      final res = await service.phoneCheck2(
        registerData['phone'],
        _phoneCheckEditing2.text,
      );
      final data = json.decode(res.bodyString!);
      if (data is Map<String, dynamic> && data.containsKey('msg')) {
        // 0 인증번호 틀림
        // 1 인증시간 만료
        if (data['msg'] == 0) {
          validCheck = 0;
        } else if (data['msg'] == 1) {
          validCheck = 1;
        }
        _phoneFormKey2.currentState!.validate();
      } else {
        if (data) {
          validCheck = -1;
          nextPage();
        }
      }
    } catch (err) {
      noTitleSnackbar('잠시 후 다시 시도해 주세요.');
    }
  }

  Future findIdCallback() async {
    final Map<String, dynamic> requestData = {
      'kind': 'findID',
      'phone': registerData['phone'],
    };
    final res = await service.tingApiGetdata(requestData);
    final data = json.decode(res.bodyString!);
    return data;
  }

  void nextPage() async {
    if (isNext && validCheck == -1) {
      if (registerData.containsKey('tab') && registerData['tab'] == 'id') {
        final res = await findIdCallback();
        Get.toNamed('/find_success', arguments: {
          'phone': registerData['phone'],
          'id': res['id'],
          'date': res['signupdate'],
        });
      } else if (registerData.containsKey('tab') &&
          registerData['tab'] == 'pwd') {
        final res = await findIdCallback();
        Get.toNamed('/password_change', arguments: {
          'phone': registerData['phone'],
          'id': res['id'],
        });
      } else {
        Get.toNamed('/register', arguments: {'phone': registerData['phone']});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
                      onPressed: () async {
                        isNext ? await phoneCheckCallback() : null;
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
