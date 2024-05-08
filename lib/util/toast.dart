import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> normalToast(
  String msg,
  Color bg, {
  ToastGravity? position,
  int? time,
}) async {
  return await Fluttertoast.showToast(
    msg: msg,
    toastLength: time == null ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
    gravity: position ?? ToastGravity.TOP,
    timeInSecForIosWeb: time ?? 1,
    backgroundColor: bg,
    textColor: Colors.white,
    fontSize: 16,
  );
}
