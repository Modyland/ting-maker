import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ting_maker/screen/onboarding/onboard_one.dart';
import 'package:ting_maker/screen/onboarding/onboard_two.dart';
import 'package:ting_maker/screen/onboarding/start_button_box.dart';
import 'package:ting_maker/widget/common_style.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController(
    viewportFraction: 1,
    keepPage: true,
  );
  final pages = [const OnePageScreen(), const TwoPageScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              itemBuilder: (_, index) {
                return pages[index % pages.length];
              },
            ),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: pages.length,
            effect: ExpandingDotsEffect(
              dotColor: grey400,
              activeDotColor: grey400,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
          const StartButtonBox(),
        ],
      ),
    );
  }
}
