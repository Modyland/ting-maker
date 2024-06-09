import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/util/regexp.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
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
  bool isNext = false;
  int validCheck = -1;

  void passwordValidCheck(String value) {
    validators['length'] = MyRegExp.eightRegex.hasMatch(value);
    validators['english'] = MyRegExp.enRegex.hasMatch(value);
    validators['number'] = MyRegExp.numRegex.hasMatch(value);
    validators['special'] = MyRegExp.specialRegex.hasMatch(value);
    setState(() {
      isNext = validators.values.every((v) => v ?? false) &&
          _idEditingController.text.isNotEmpty;
    });
  }

  Future changePassword() async {
    Log.e(registerData['id']);
    if (registerData['id'] != _idEditingController.text) {
      validCheck = 1;
      _accountFormkey.currentState!.validate();
      return;
    }
    final Map<String, dynamic> requestData = {
      'kind': 'updatePWD',
      'id': _idEditingController.text,
      'pwd': _pwdEditingController.text,
    };
    final res = await service.tingApiGetdata(requestData);
    final data = json.decode(res.bodyString!);
    if (data) {
      validCheck = -1;
      noTitleSnackbar('비밀번호가 변경되었습니다.');
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                      '\t\t가입한 아이디를 입력해주세요.',
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
                          return '아이디를 확인해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Text('\t새 비밀번호', style: registerTitleStyle),
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
                          validators['length'] == null
                              ? grey500
                              : validators['length'] == false
                                  ? errColor
                                  : okColor,
                          '8자 이상',
                          validators['english'] == null
                              ? grey500
                              : validators['english'] == false
                                  ? errColor
                                  : okColor,
                          '영문 포함',
                        ),
                        checkPasswordRow(
                          validators['number'] == null
                              ? grey500
                              : validators['number'] == false
                                  ? errColor
                                  : okColor,
                          '숫자 포함',
                          validators['special'] == null
                              ? grey500
                              : validators['special'] == false
                                  ? errColor
                                  : okColor,
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
                        onPressed: () async {
                          isNext ? await changePassword() : null;
                        },
                        child: Center(
                          child: Text(
                            '비밀번호 변경',
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
