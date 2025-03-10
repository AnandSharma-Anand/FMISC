



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String baseUrl="https://pioneersparklellc.com/api";
Color appColor=const Color(0xFF0f4c9f);

LinearGradient linearGradient=LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade100,Colors.blue.shade100, Colors.blue.shade400], begin: Alignment.topCenter, end: Alignment.bottomCenter);

void showLongToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM, // Ensures no additional icons are shown
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
