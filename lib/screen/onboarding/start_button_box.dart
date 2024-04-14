import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartButtonBox extends StatelessWidget {
  const StartButtonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 19, 30, 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            height: 52,
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
                Get.toNamed('/permission');
              },
              child: const Center(
                child: Text(
                  '시작하기',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0XFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 19,
          ),
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
                  style: const TextStyle(
                    color: Color(0XFF00BFFE),
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.offAndToNamed('/login'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
