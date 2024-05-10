import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/util/toast.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';

class FindSuccessScreen extends StatefulWidget {
  const FindSuccessScreen({super.key});

  @override
  State<FindSuccessScreen> createState() => _FindSuccessScreenState();
}

class _FindSuccessScreenState extends State<FindSuccessScreen> {
  Map<String, dynamic> registerData = Get.arguments;

  void idConfirm() async {
    await normalToast('아이디 : ${registerData['id']}', pointColor, time: 3);
    Get.toNamed('/login');
  }

  void nextPasswordChange() {
    Get.toNamed('/password_change', arguments: registerData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Center(
          child: Column(
            children: [
              const Text('해당 휴대전화 번호로 가입된 아이디입니다.'),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                padding: const EdgeInsets.fromLTRB(40, 25, 12, 25),
                width: double.infinity,
                height: MyApp.height * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: pointColor, width: 4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('아이디 : ${registerData['id']}'),
                    Text(
                        '가입일 : ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(registerData['date']))}'),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MyApp.width * 0.4,
                    height: 46,
                    decoration: enableButton,
                    child: MaterialButton(
                      animationDuration: Durations.short4,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        idConfirm();
                      },
                      child: const Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MyApp.width * 0.4,
                    height: 46,
                    decoration: enableButton,
                    child: MaterialButton(
                      animationDuration: Durations.short4,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        nextPasswordChange();
                      },
                      child: const Center(
                        child: Text(
                          '비밀번호 재설정',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
