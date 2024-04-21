import 'package:flutter/material.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_style.dart';

class OnePageScreen extends StatefulWidget {
  const OnePageScreen({super.key});

  @override
  State<OnePageScreen> createState() => _OnePageScreenState();
}

class _OnePageScreenState extends State<OnePageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '여기서 뭐하지?',
                style: onboardTitleStyle,
              ),
              Text(
                '빠르고 쉬운 실시간 동네 소모임',
                style: onboardRegularStyle,
              ),
              Text(
                '어렵지 않아요',
                style: onboardRegularStyle,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          -_controller.value * MyApp.width,
                          0.0,
                        ),
                        child: child,
                      );
                    },
                    child: Image.asset('assets/image/onboard1.png'),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          (1.0 - _controller.value) * MyApp.width,
                          0.0,
                        ),
                        child: child,
                      );
                    },
                    child: Image.asset('assets/image/onboard1.png'),
                  ),
                ],
              ),
              Stack(
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _controller.value * MyApp.width,
                          0.0,
                        ),
                        child: child,
                      );
                    },
                    child: Image.asset('assets/image/onboard2.png'),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          -1.0 * MyApp.width + _controller.value * MyApp.width,
                          0.0,
                        ),
                        child: child,
                      );
                    },
                    child: Image.asset('assets/image/onboard2.png'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
