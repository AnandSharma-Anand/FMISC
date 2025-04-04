
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

Color appColor=const Color(0xFF0f4c9f);


Widget commonAppbar() {
  return Container(
    color: appColor,
    width: Get.width,
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        Container(
          // padding: ,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
          child: Image.asset("assets/logo.png", height: 40).marginAll(3),
        ).marginOnly(right: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Text("FMISC APPLICATION", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)).marginOnly(top: 5)]),
          ],
        ),
        Spacer(),
        /* IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),*/
      ],
    ),
  );
}


void showToast({String message=""}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
    gravity: ToastGravity.BOTTOM, // Position: TOP, CENTER, BOTTOM
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}


String baseUrl="https://pioneersparklellc.com/api";

LinearGradient linearGradient=LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade100,Colors.blue.shade100, Colors.blue.shade400], begin: Alignment.topCenter, end: Alignment.bottomCenter);

