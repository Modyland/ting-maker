import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/service/sample_service.dart';
import 'package:ting_maker/util/regexp.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class PhoneCheckScreen extends StatefulWidget {
  const PhoneCheckScreen({super.key});

  @override
  State<PhoneCheckScreen> createState() => _PhoneCheckScreenState();
}

class _PhoneCheckScreenState extends State<PhoneCheckScreen> {
  final TextEditingController _editingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNext = false;

  final service = Get.find<SampleProvider>();
  void phoneCheckCallback() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final res = await service.phoneCheck(_editingController.text);
    final data = json.decode(res.body);
    if (data) {
      Get.toNamed('/phone_check2',
          arguments: {'phone': _editingController.text});
    }
  }

  @override
  void dispose() {
    _editingController.dispose();
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
                  Text('\t안녕하세요!', style: registerTitleStyle),
                  Text('\t휴대폰 번호를 입력해주세요.', style: registerTitleStyle),
                  const SizedBox(height: 10),
                  const Text(
                    '\t\t휴대폰 번호는 안전하게 보관되며 타인에게 공개되지 않아요.',
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      controller: _editingController,
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
                      onPressed: () {
                        isNext ? phoneCheckCallback() : null;
                      },
                      child: Center(
                        child: Text(
                          '인증 문자 받기',
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
        ],
      ),
    );
  }
}
