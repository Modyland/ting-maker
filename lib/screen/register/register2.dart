import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/util/f_logger.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/date_bottom_sheet.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({super.key});

  @override
  State<RegisterScreen2> createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  final TextEditingController _birthdayController = TextEditingController();
  bool isNext = false;

//CupertinoDatePicker(
  //      onDateTimeChanged = (value) {},
  //      mode = CupertinoDatePickerMode.date,
  //       maximumYear = DateTime.now().year,
  //       ))

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\t성별을 선택해주세요', style: registerTitleStyle),
                const SizedBox(height: 10),
                ToggleSwitch(
                  minWidth: MyApp.width * 0.8,
                  minHeight: 50,
                  cornerRadius: 10,
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color(0xffbcc0c6),
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ['남자', '여자'],
                  customTextStyles: const [
                    TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                  icons: const [
                    Icons.male,
                    Icons.female,
                  ],
                  iconSize: 30.0,
                  borderWidth: 2.0,
                  borderColor: const [
                    Color(0xffbcc0c6),
                  ],
                  activeBgColors: const [
                    [
                      Color(0XFF00BFFE),
                    ],
                    [
                      Color(0XFF00BFFE),
                    ],
                  ],
                  onToggle: (index) {
                    Log.e('switched to: $index');
                  },
                ),
                const SizedBox(height: 15),
                Text('\t생년월일을 선택해주세요', style: registerTitleStyle),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    datePickerBottomSheet();
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: _birthdayController,
                    decoration: inputDecoration('YYYY-MM-DD'),
                    style: const TextStyle(fontSize: 20),
                    onChanged: (value) {},
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
                    onPressed: () {
                      isNext ? null : null;
                    },
                    child: Center(
                      child: Text(
                        '다음',
                        style: TextStyle(
                          fontSize: 16,
                          color: isNext
                              ? const Color(0xffffffff)
                              : const Color(0xff9FA3AB),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
