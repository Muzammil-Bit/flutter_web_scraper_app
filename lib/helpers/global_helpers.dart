import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

errorToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.red,
    webPosition: 'center',
    webBgColor: "#FF0000",
    timeInSecForIosWeb: 3,
  );
}
