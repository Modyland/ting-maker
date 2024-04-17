import 'package:flutter/material.dart';
import 'package:ting_maker/util/regexp.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNext = false;

  Map<String, bool> firstValid = {'err': false, 'ok': false};
  Map<String, bool> secondValid = {'err': false, 'ok': false};
  Map<String, bool> thirdValid = {'err': false, 'ok': false};
  Map<String, bool> forthValid = {'err': false, 'ok': false};

  void passwordValidCheck(String value) {
    //false, false -> 기본색
    //true, false -> 에러색
    //false, true -> 초록색
    if (eightRegex.hasMatch(value)) {
      firstValid['ok'] = true;
      firstValid['err'] = false;
    } else {
      firstValid['err'] = true;
      firstValid['ok'] = false;
    }
    if (enRegex.hasMatch(value)) {
      secondValid['ok'] = true;
      secondValid['err'] = false;
    } else {
      secondValid['err'] = true;
      secondValid['ok'] = false;
    }
    if (numRegex.hasMatch(value)) {
      thirdValid['ok'] = true;
      thirdValid['err'] = false;
    } else {
      thirdValid['err'] = true;
      thirdValid['ok'] = false;
    }
    if (specialRegex.hasMatch(value)) {
      forthValid['ok'] = true;
      forthValid['err'] = false;
    } else {
      forthValid['err'] = true;
      forthValid['ok'] = false;
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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      decoration: inputDecoration('아이디를 입력해주세요'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Text('\t비밀번호', style: registerTitleStyle),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: inputDecoration('비밀번호를 입력해주세요'),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    const Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Color(0xff717680),
                              size: 16,
                            ),
                            Text(
                              '8자 이상',
                              style: TextStyle(
                                color: Color(0xff717680),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.check),
                            Text('영문 포함')
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.check),
                            Text('숫자 포함'),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.check),
                            Text("특수문자 포함 (!@#\$%^&*)")
                          ],
                        )
                      ],
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
                          isNext ? null : null;
                        },
                        child: Center(
                          child: Text(
                            '다음',
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
            ),
          ),
        ],
      ),
    );
  }
}
