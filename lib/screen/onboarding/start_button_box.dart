import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_style.dart';

class StartButtonBox extends StatelessWidget {
  const StartButtonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        MyApp.width * 0.1,
        MyApp.height * 0.03,
        MyApp.width * 0.1,
        MyApp.height * 0.03,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            height: 52,
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
                Get.toNamed('/service_agree');
              },
              child: Center(
                child: Text(
                  '시작하기',
                  style: buttonWhiteTextStyle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 19),
          RichText(
            text: TextSpan(
              text: '이미 계정이 있나요?\t\t',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '로그인',
                  style: TextStyle(
                    color: pointColor,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.offAndToNamed('/login');
                    },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
