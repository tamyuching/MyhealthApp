import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ToastUtil {
  static showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      // pop up position
      timeInSecForIosWeb: 1,
    );
  }
}
