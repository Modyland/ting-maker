import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle _labelStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  final TextStyle _findStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w100,
      color: Color(0xffBCC0C6),
      height: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 110, 0, 30),
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
                    Text(
                      '아이디',
                      style: _labelStyle,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: inputDecoration('아이디를 입력하세요'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력하세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Text('비밀번호', style: _labelStyle),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: inputDecoration('비밀번호를 입력하세요'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력하세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '아이디 찾기',
                            style: _findStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed('/find_id_pwd',
                                  arguments: {'tab': 'id'}),
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 1,
                          color: const Color(0xffBCC0C6),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '비밀번호 찾기',
                            style: _findStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed('/find_id_pwd',
                                  arguments: {'tab': 'pwd'}),
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
                        color: const Color(0XFF00BFFE),
                      ),
                      child: MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // 유효성 검사를 통과하면 실행될 코드를 작성합니다.
                            // 예를 들어, 로그인 로직을 여기에 구현할 수 있습니다.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('로그인 처리 중...')),
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0XFFFFFFFF),
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
      ),
    );
  }
}
