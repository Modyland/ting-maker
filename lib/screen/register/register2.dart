import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({super.key});

  @override
  State<RegisterScreen2> createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  Map<String, dynamic> registerData = Get.arguments;
  final GlobalKey<FormState> _dateFormKey = GlobalKey<FormState>();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _dayFocus = FocusNode();
  bool female = false;
  bool male = false;

  bool year = false;
  bool month = false;
  bool day = false;

  bool isNext = false;

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();
    super.dispose();
  }

  void genderSelect(int type) {
    if (type == 0) {
      female = true;
      male = false;
    } else {
      female = false;
      male = true;
    }
    isNextCheck();
  }

  void isNextCheck() {
    setState(() {
      isNext = year && month && day && (female || male);
    });
  }

  void nextPage() {
    Get.toNamed('/register3', arguments: {
      'phone': registerData['phone'],
      'id': registerData['id'],
      'pwd': registerData['pwd'],
      'gender': female ? 'woman' : 'man',
      'birth':
          '${_yearController.text}${_monthController.text}${_dayController.text}'
    });
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
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
              child: Form(
                key: _dateFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\t성별', style: registerTitleStyle),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Opacity(
                          opacity: female ? 1.0 : 0.5,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              genderSelect(0);
                            },
                            child: const Text(
                              '\u{1F467}',
                              style: TextStyle(fontSize: 100),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: male ? 1.0 : 0.5,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              genderSelect(1);
                            },
                            child: const Text(
                              '\u{1F466}',
                              style: TextStyle(fontSize: 100),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text('\t생년월일', style: registerTitleStyle),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: TextFormField(
                            controller: _yearController,
                            decoration: inputDecoration('년(YYYY)'),
                            keyboardType: TextInputType.datetime,
                            maxLength: 4,
                            buildCounter: (BuildContext context,
                                    {required int currentLength,
                                    required bool isFocused,
                                    required int? maxLength}) =>
                                null,
                            style: const TextStyle(fontSize: 20),
                            onChanged: (value) {
                              year = value.length == 4;
                              if (year) {
                                _monthFocus.requestFocus();
                              }
                              isNextCheck();
                            },
                            validator: (value) {
                              if (value != null &&
                                  !RegExp(r'^-?[0-9]+$').hasMatch(value)) {
                                return '숫자만 입력 가능합니다';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                            flex: 2,
                            child: TextFormField(
                              controller: _monthController,
                              focusNode: _monthFocus,
                              decoration: inputDecoration('월(MM)'),
                              keyboardType: TextInputType.datetime,
                              maxLength: 2,
                              buildCounter: (BuildContext context,
                                      {required int currentLength,
                                      required bool isFocused,
                                      required int? maxLength}) =>
                                  null,
                              style: const TextStyle(fontSize: 20),
                              onChanged: (value) {
                                month = value.length == 2;
                                isNextCheck();
                                if (month) {
                                  _dayFocus.requestFocus();
                                }
                              },
                              validator: (value) {
                                if (value != null &&
                                    !RegExp(r'^-?[0-9]+$').hasMatch(value)) {
                                  return '숫자만 입력 가능합니다';
                                }
                                return null;
                              },
                            )),
                        const SizedBox(width: 12),
                        Flexible(
                            flex: 2,
                            child: TextFormField(
                              controller: _dayController,
                              focusNode: _dayFocus,
                              decoration: inputDecoration('일(DD)'),
                              keyboardType: TextInputType.datetime,
                              maxLength: 2,
                              buildCounter: (BuildContext context,
                                      {required int currentLength,
                                      required bool isFocused,
                                      required int? maxLength}) =>
                                  null,
                              style: const TextStyle(fontSize: 20),
                              onChanged: (value) {
                                day = value.length == 2;
                                isNextCheck();
                                if (year && month && day) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }
                              },
                              validator: (value) {
                                if (value != null &&
                                    !RegExp(r'^-?[0-9]+$').hasMatch(value)) {
                                  return '숫자만 입력 가능합니다';
                                }
                                return null;
                              },
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '생년월일은 공개되지 않으며 본인확인용으로만 사용됩니다.',
                      style: TextStyle(
                        fontSize: 12,
                        color: grey500,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 10),
                    Text(
                      'TING은 모든 가입자의 신원을 검증하며, 거짓 정보를 입력하거나 타인의 정보를 도용할 경우 법적 처벌을 받을 수 있습니다.',
                      style: TextStyle(
                        fontSize: 12,
                        color: grey500,
                      ),
                    ),
                    const SizedBox(height: 5),
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
