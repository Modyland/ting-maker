import 'package:flutter/material.dart';

class TwoPageScreen extends StatelessWidget {
  const TwoPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const regularStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 160, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '지금 여기를 제일 알차게\n즐기는 법!',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const Text(
                '\t\t\t동네 정보부터, 메이트까지',
                style: regularStyle,
              ),
              const Text(
                '\t\t\t빠르고 알차게 즐겨보세요.',
                style: regularStyle,
              ),
              const SizedBox(height: 10),
              Image.asset('assets/image/onboard_back.png'),
            ],
          ),
        ],
      ),
    );
  }
}
