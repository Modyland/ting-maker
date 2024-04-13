import 'package:flutter/material.dart';
import 'package:ting_maker/widget/common_appbar.dart';

class PhoneCheckScreen extends StatefulWidget {
  const PhoneCheckScreen({super.key});

  @override
  State<PhoneCheckScreen> createState() => _PhoneCheckScreenState();
}

class _PhoneCheckScreenState extends State<PhoneCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                TextFormField(
                  initialValue: '아이디',
                ),
                TextFormField(
                  initialValue: '패스워드',
                ),
                TextFormField(
                  initialValue: '아이디',
                ),
                TextFormField(
                  initialValue: '패스워드',
                ),
                TextFormField(
                  initialValue: '아이디',
                ),
                TextFormField(
                  initialValue: '패스워드',
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('로그인'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
