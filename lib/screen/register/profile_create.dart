import 'package:flutter/material.dart';
import 'package:ting_maker/service/sample_service.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
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
                      decoration: inputDecoration('휴대폰 번호 ( - 없이 숫자만 입력 )'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '휴대폰 번호를 입력하세요';
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
