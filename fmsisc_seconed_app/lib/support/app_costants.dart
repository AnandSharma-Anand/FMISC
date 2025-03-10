



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String baseUrl="https://pioneersparklellc.com/api";
Color appColor= Colors.indigo.shade800;


LinearGradient linearGradient=LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade100,Colors.blue.shade100, Colors.blue.shade400], begin: Alignment.topCenter, end: Alignment.bottomCenter);

void showLongToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    fontSize: 18.0,
  );
}
