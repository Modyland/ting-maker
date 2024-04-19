import 'package:flutter/material.dart';
import 'package:ting_maker/service/sample_service.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/image_profile.dart';

class RegisterScreen3 extends StatefulWidget {
  const RegisterScreen3({super.key});

  @override
  State<RegisterScreen3> createState() => _RegisterScreen3State();
}

class _RegisterScreen3State extends State<RegisterScreen3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNext = false;

  final service = SampleProvider();

  void test() {
    // service.getUser(id);
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
                  const ImageProfile(),
                  const SizedBox(height: 10),
                  Text('\t닉네임', style: registerTitleStyle),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: inputDecoration('닉네임을 입력해주세요'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '신중하게 본인을 가장 잘 나타내는 이름으로 설정해주세요',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff717680),
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
                        isNext ? null : null;
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
