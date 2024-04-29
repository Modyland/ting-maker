import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

Color pointColor = const Color(0XFF00BFFE);
Color grey300 = const Color(0XFFBCC0C6);
Color grey400 = const Color(0XFF9FA3AB);
Color grey500 = const Color(0XFF717680);
Color errColor = Colors.red.shade400;
Color okColor = Colors.green.shade400;

TextStyle onboardTitleStyle = const TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.w800,
  color: Colors.black,
);

TextStyle onboardRegularStyle = const TextStyle(
  fontSize: 16,
  color: Colors.black,
);

TextStyle registerTitleStyle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.black,
);

TextStyle buttonWhiteTextStyle = const TextStyle(
  fontSize: 16,
  color: Colors.white,
);

BoxDecoration enableButton = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: pointColor,
  border: Border.all(
    color: Colors.black38,
    width: 1,
  ),
);

BoxDecoration disableButton = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: Colors.transparent,
  border: Border.all(
    color: grey300,
    width: 1,
  ),
);

InputDecoration inputDecoration(
  String hint, {
  bool? isObscure,
  bool? suffix,
  VoidCallback? suffixCallback,
}) {
  return InputDecoration(
      hintText: hint,
      suffixIcon: suffix == true
          ? IconButton(
              onPressed: () {
                suffixCallback!();
              },
              icon: Icon(
                  size: 25,
                  color: grey300,
                  isObscure == true ? Icons.visibility : Icons.visibility_off))
          : null,
      errorStyle: TextStyle(color: errColor),
      hintStyle: TextStyle(fontSize: 14, color: grey400),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: grey300, width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: grey300, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: grey300, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: errColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: errColor, width: 1.0),
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
          size: 24,
          border: Border.all(
            width: 1.5,
            color: grey400,
          ),
          checkedColor: pointColor,
          checkedWidget: const Icon(
            Icons.check,
            color: Colors.white,
            size: 17,
          ),
          uncheckedColor: Colors.transparent,
          uncheckedWidget: Icon(
            Icons.check,
            color: grey400,
            size: 17,
          ),
          animationDuration: const Duration(milliseconds: 100),
        ),
      ),
      const SizedBox(width: 10),
      const Text(
        '모두 동의',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
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
        checkedWidget: Icon(
          Icons.check,
          color: pointColor,
        ),
        uncheckedColor: Colors.transparent,
        uncheckedWidget: Icon(
          Icons.check,
          color: grey400,
        ),
        animationDuration: const Duration(milliseconds: 100),
      ),
      const SizedBox(width: 6),
      Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: grey500,
        ),
      ),
      const Spacer(),
      RichText(
        text: TextSpan(
          text: '보기',
          style: TextStyle(
            color: grey400,
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

Row checkPasswordRow(
  Color firstColor,
  String firstText,
  Color secondColor,
  String secondText,
) {
  return Row(
    children: <Widget>[
      Icon(
        Icons.check,
        color: firstColor,
        size: 16,
      ),
      Text(
        firstText,
        style: TextStyle(
          color: firstColor,
          fontSize: 12,
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Icon(
        Icons.check,
        color: secondColor,
        size: 16,
      ),
      Text(
        secondText,
        style: TextStyle(
          color: secondColor,
          fontSize: 12,
        ),
      )
    ],
  );
}
