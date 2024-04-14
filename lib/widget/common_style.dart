import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xff9FA3AB)),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xffbcc0c6), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xffbcc0c6), width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),
      ));
}

Widget allCheckRow(bool allCheck, Function(bool selected) checkChange) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: RoundCheckBox(
          isChecked: allCheck,
          onTap: (selected) {
            checkChange(selected!);
          },
          size: 20,
          border: Border.all(
            width: 1.5,
            color: const Color(0xff9FA3AB),
          ),
          checkedColor: const Color(0XFF00BFFE),
          checkedWidget: const Icon(
            Icons.check,
            color: Colors.white,
            size: 14,
          ),
          uncheckedColor: Colors.transparent,
          uncheckedWidget: const Icon(
            Icons.check,
            color: Color(0xff9FA3AB),
            size: 14,
          ),
          animationDuration: const Duration(milliseconds: 100),
        ),
      ),
      const SizedBox(width: 14),
      const Text(
        '모두 동의',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      )
    ],
  );
}

Widget oneCheckRow(
  bool checkValue,
  String text,
  Function(bool selected) checkChange,
  VoidCallback moveCallback,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      RoundCheckBox(
        isChecked: checkValue,
        onTap: (selected) {
          checkChange(selected!);
        },
        border: const Border.symmetric(
            vertical: BorderSide.none, horizontal: BorderSide.none),
        checkedColor: Colors.transparent,
        checkedWidget: const Icon(
          Icons.check,
          color: Color(0XFF00BFFE),
        ),
        uncheckedColor: Colors.transparent,
        uncheckedWidget: const Icon(
          Icons.check,
          color: Color(0xff9FA3AB),
        ),
        animationDuration: const Duration(milliseconds: 100),
      ),
      const SizedBox(width: 6),
      Text(
        text,
        style: const TextStyle(fontSize: 14, color: Color(0xff717680)),
      ),
      const Spacer(),
      RichText(
        text: TextSpan(
          text: '보기',
          style: const TextStyle(
            color: Color(0xff9FA3AB),
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              moveCallback();
            },
        ),
      )
    ],
  );
}

TextStyle registerTitleStyle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

BoxDecoration enableButton = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: const Color(0XFF00BFFE),
);

BoxDecoration disableButton = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: Colors.transparent,
  border: Border.all(
    color: const Color(0xffbcc0c6),
    width: 1,
  ),
);
