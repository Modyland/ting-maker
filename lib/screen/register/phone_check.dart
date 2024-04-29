import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/util/regexp.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class PhoneCheckScreen extends StatefulWidget {
  const PhoneCheckScreen({super.key});

  @override
  State<PhoneCheckScreen> createState() => _PhoneCheckScreenState();
}

class _PhoneCheckScreenState extends State<PhoneCheckScreen> {
  Map<String, dynamic>? registerData = Get.arguments;
  final GlobalKey<FormState> _phoneFormkey = GlobalKey<FormState>();
  final TextEditingController _phoneCheckEditing = TextEditingController();
  bool isNext = false;
  int validCheck = -1;

  @override
  void dispose() {
    _phoneCheckEditing.dispose();
    super.dispose();
  }

  Future phoneCheckCallback() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final res = await service.phoneCheck(
        _phoneCheckEditing.text, Get.arguments == null ? true : false);
    final data = json.decode(res.bodyString!);
    if (data is Map<String, dynamic> && data.containsKey('msg')) {
      // 0 이미 가입된 휴대폰
      // 1 인증 횟수 초과
      if (data['msg'] == 0) {
        validCheck = 0;
      } else if (data['msg'] == 1) {
        validCheck = 1;
      }
      _phoneFormkey.currentState!.validate();
    } else {
      if (data) {
        validCheck = -1;
        nextPage();
      }
    }
  }

  void nextPage() {
    if (isNext && validCheck == -1) {
      final args = {'phone': _phoneCheckEditing.text};
      if (Get.arguments != null) {
        args['tab'] = Get.arguments['tab'];
      }
      Get.toNamed('/phone_check2', arguments: args);
    }
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
                  if (Get.arguments == null)
                    Text('\t안녕하세요!', style: registerTitleStyle),
                  Text('\t휴대폰 번호를 입력해주세요.', style: registerTitleStyle),
                  const SizedBox(height: 10),
                  const Text(
                    '\t\t휴대폰 번호는 안전하게 보관되며 타인에게 공개되지 않아요.',
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _phoneFormkey,
                    child: TextFormField(
                      autofocus: true,
                      controller: _phoneCheckEditing,
                      decoration: inputDecoration('휴대폰 번호 ( - 없이 숫자만 입력 )'),
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      onChanged: (value) {
                        setState(() {
                          isNext = value.length == 11;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '휴대폰 번호를 입력하세요';
                        } else if (!phoneNumberRegex.hasMatch(value)) {
                          return '휴대폰 번호 형식이 일치하지 않습니다.';
                        } else if (validCheck == 0) {
                          return '이미 가입된 휴대폰 번호 입니다.';
                        } else if (validCheck == 1) {
                          return '하루 인증 횟수를 초과하였습니다.';
                        }
                        return null;
                      },
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
                          '인증 문자 받기',
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
