import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/profile_controller.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/screen/register/profile/image_profile.dart';
import 'package:ting_maker/util/toast.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class RegisterScreen3 extends StatefulWidget {
  const RegisterScreen3({super.key});

  @override
  State<RegisterScreen3> createState() => _RegisterScreen3State();
}

final ImageProfileController imageProfileController =
    Get.put(ImageProfileController());

class _RegisterScreen3State extends State<RegisterScreen3> {
  Map<String, dynamic> registerData = Get.arguments;
  final GlobalKey<FormState> _nickNameFormKey = GlobalKey<FormState>();
  final TextEditingController _nickNameEditing = TextEditingController();

  bool isNext = false;

  Future<void> goSignup() async {
    final Map<String, dynamic> requestData = {
      'kind': 'signUp',
      'id': registerData['id'],
      'pwd': registerData['pwd'],
      'phone': registerData['phone'],
      'birth': registerData['birth'],
      'gender': registerData['gender'],
      'aka': _nickNameEditing.text,
    };
    if (imageProfileController.getFinishCropImage != null) {
      requestData['profile'] = imageProfileController.getFinishCropImage;
    }
    final res = await service.tingApiGetdata(requestData);
    final data = json.decode(res.bodyString!);
    if (data) {
      imageProfileController.dispose();
      await normalToast('회원가입이 완료되었습니다.', pointColor, time: 3);
      Get.offAllNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    imageProfileController.clearCropImage();
  }

  @override
  void dispose() {
    _nickNameEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
                    key: _nickNameFormKey,
                    child: TextFormField(
                      controller: _nickNameEditing,
                      keyboardType: TextInputType.text,
                      decoration: inputDecoration('닉네임을 입력해주세요 (2글자 이상)'),
                      onChanged: (value) {
                        setState(() {
                          isNext = value.length >= 2;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요';
                        } else if (2 > value.length) {
                          return '닉네임은 최소 2글자 이상이어야 합니다';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '신중하게 본인을 가장 잘 나타내는 이름으로 설정해주세요',
                    style: TextStyle(
                      fontSize: 12,
                      color: grey500,
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
                        isNext ? await goSignup() : null;
                      },
                      child: Center(
                        child: Text(
                          '가입하기',
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
