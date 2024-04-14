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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '지금 여기를 제일 알차게\n즐기는 법!',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              Text(
                '\t\t\t동네 정보부터, 메이트까지',
                style: regularStyle,
              ),
              Text(
                '\t\t\t빠르고 알차게 즐겨보세요.',
                style: regularStyle,
              )
            ],
          ),
        ],
      ),
    );
  }
}