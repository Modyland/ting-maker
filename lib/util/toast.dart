import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> normalToast(
  String msg,
  Color bg, {
  ToastGravity? position,
}) async {
  return await Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: position ?? ToastGravity.TOP,
    timeInSecForIosWeb: 2,
    backgroundColor: bg,
    textColor: Colors.white,
    fontSize: 16,
  );
}
