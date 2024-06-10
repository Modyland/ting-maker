import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_style.dart';

class TwoPageScreen extends StatelessWidget {
  const TwoPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        0,
        MyApp.height * 0.15,
        0,
        MyApp.height * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText(
                    speed: Durations.short2,
                    '지금 여기를 제일 알차게\n즐기는 법!',
                    textStyle: onboardTitleStyle,
                  ),
                ],
              ),
              AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText(
                    speed: Durations.short2,
                    '\t\t\t동네 정보부터, 메이트까지',
                    textStyle: onboardRegularStyle,
                  ),
                ],
              ),
              AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText(
                    speed: Durations.short2,
                    '\t\t\t빠르고 알차게 즐겨보세요.',
                    textStyle: onboardRegularStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          Image.asset(
            'assets/image/onboard_back.png',
            height: MyApp.height * 0.3,
          ),
        ],
      ),
    );
  }
}
