import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/person.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

const TextStyle _labelStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.black,
);

const TextStyle _findStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Colors.black,
  height: 1,
);

class _LoginScreenState extends State<LoginScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idEditingController = TextEditingController();
  final TextEditingController _pwdEditingController = TextEditingController();
  int validCheck = -1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  void loginService() async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      final Map<String, dynamic> requestData = {
        'kind': 'login',
        'id': _idEditingController.text,
        'pwd': _pwdEditingController.text,
        'guard': 0
      };
      final res = await service.tingApiGetdata(requestData);
      final data = json.decode(res.bodyString!);
      if (data is Map<String, dynamic> && data.containsKey('msg')) {
        if (data['msg'] == 0) {
          validCheck = 0;
        }
        _formKey.currentState!.validate();
      } else if (data is Map<String, dynamic> && data.containsKey('profile')) {
        final profile = json.decode(data['profile']);
        validCheck = -1;
        final Person person = Person.fromJson(profile);
        await utilBox.put('isLogin', true);
        await personBox.put('person', person);
        nextPage();
      }
    } catch (err) {
      titleSnackbar('로그인 오류', '접속이 원활하지 않습니다.');
    }
  }

  void nextPage() {
    Get.offAllNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  0,
                  MyApp.height * 0.1,
                  0,
                  MyApp.height * 0.05,
                ),
                child: SvgPicture.asset('assets/image/logo.svg'),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      '아이디',
                      style: _labelStyle,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _idEditingController,
                      decoration: inputDecoration('아이디를 입력하세요'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력하세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '비밀번호',
                      style: _labelStyle,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _pwdEditingController,
                      obscureText: true,
                      decoration: inputDecoration('비밀번호를 입력하세요'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력하세요';
                        } else if (validCheck == 0) {
                          return '아이디 또는 비밀번호를 확인해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '아이디 찾기',
                            style: _findStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(
                                  '/phone_check',
                                  arguments: {'tab': 'id'},
                                );
                              },
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 1,
                          color: Colors.black,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '비밀번호 찾기',
                            style: _findStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(
                                  '/phone_check',
                                  arguments: {'tab': 'pwd'},
                                );
                              },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: pointColor,
                      ),
                      child: MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          loginService();
                        },
                        child: Center(
                          child: Text(
                            '로그인',
                            style: buttonWhiteTextStyle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: '계정이 없으신가요?\t\t',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '회원가입',
                              style: TextStyle(
                                color: pointColor,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed('/service_agree');
                                },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
