import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/screen/register/phone_check.dart';
import 'package:ting_maker/util/regexp.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Map<String, dynamic> registerData = Get.arguments;
  final GlobalKey<FormState> _accountFormkey = GlobalKey<FormState>();
  final TextEditingController _idEditingController = TextEditingController();
  final TextEditingController _pwdEditingController = TextEditingController();
  Map<String, bool?> validators = {
    'length': null,
    'english': null,
    'number': null,
    'special': null
  };
  bool isObscure = false;
  bool idCheck = false;
  bool isNext = false;
  int validCheck = -1;

  void passwordValidCheck(String value) {
    validators['length'] = eightRegex.hasMatch(value);
    validators['english'] = enRegex.hasMatch(value);
    validators['number'] = numRegex.hasMatch(value);
    validators['special'] = specialRegex.hasMatch(value);
    setState(() {
      isNext = validators.values.every((v) => v ?? false) && idCheck;
    });
  }

  void isIdCheck() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final Map<String, dynamic> requestData = {
      'kind': 'idDupe',
      'id': _idEditingController.text,
    };
    final res = await service.exsistIdCheck(requestData);
    final data = json.decode(res.body);
    if (res.body is Map<String, dynamic> && res.body.containsKey('msg')) {
      validCheck = 1;
      _accountFormkey.currentState!.validate();
    } else {
      if (data) {
        idCheck = true;
      }
    }
  }

  void nextPage() {
    if (isNext && idCheck) {
      Get.toNamed('/register2', arguments: {
        'phone': registerData['phone'],
        'id': _idEditingController.text,
        'pwd': _pwdEditingController.text
      });
    }
  }

  @override
  void dispose() {
    _idEditingController.dispose();
    _pwdEditingController.dispose();
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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Form(
                key: _accountFormkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\t아이디', style: registerTitleStyle),
                    const Text(
                      '\t\t아이디는 로그인용으로만 사용됩니다.',
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _idEditingController,
                      decoration: inputDecoration('아이디를 입력해주세요'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력해주세요';
                        } else if (validCheck == 1) {
                          return '이미 사용중인 아이디 입니다.';
                        } else if (!idCheck) {
                          return '아이디 중복확인이 필요합니다.';
                        }
                        validCheck = -1;
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Text('\t비밀번호', style: registerTitleStyle),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: !isObscure,
                      controller: _pwdEditingController,
                      decoration: inputDecoration(
                        '비밀번호를 입력해주세요',
                        isObscure: isObscure,
                        suffix: true,
                        suffixCallback: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                      onTap: _idEditingController.text.isNotEmpty
                          ? isIdCheck
                          : null,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        passwordValidCheck(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        checkPasswordRow(
                          validators['length'] ?? false ? errColor : grey500,
                          '8자 이상',
                          validators['english'] ?? false ? errColor : grey500,
                          '영문 포함',
                        ),
                        checkPasswordRow(
                          validators['number'] ?? false ? errColor : grey500,
                          '숫자 포함',
                          validators['special'] ?? false ? errColor : grey500,
                          '특수문자 포함 (!@#\$%^&*)',
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
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
                          isNext ? nextPage() : null;
                        },
                        child: Center(
                          child: Text(
                            '다음',
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
          ),
        ],
      ),
    );
  }
}
