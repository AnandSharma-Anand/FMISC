import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(String url, String fileName) async {
  if (await Permission.storage.request().isGranted) {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/$fileName';

      Dio dio = Dio();
      Response<dynamic> response = await dio.download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          print('Download progress: ${(count / total * 100).toStringAsFixed(0)}%');
        },
      );

      print('File downloaded to ${response.statusCode}');
      print('File downloaded to $filePath');
    } catch (e) {
      print('Download failed: $e');
    }
  } else {
    print('Permission denied');
  }
}

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.request();

  if (status.isGranted) {
    print("Permission Granted");
  } else if (status.isDenied) {
    print("Permission Denied");
  } else if (status.isPermanentlyDenied) {
    print("Permission Permanently Denied. Open settings.");
    openAppSettings(); // Opens app settings for the user
  }
}

String baseUrl = "https://pioneersparklellc.com/api";
Color appColor = const Color(0xFF0f4c9f);

LinearGradient linearGradient = LinearGradient(
  colors: [Colors.blue.shade400, Colors.blue.shade100, Colors.blue.shade100, Colors.blue.shade400],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
LinearGradient newLinearGradient = LinearGradient(
  colors: [Colors.white, Colors.white, Colors.white, Colors.white],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

void showLongToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    // Ensures no additional icons are shown
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<void> requestPermissions() async {
  await Permission.storage.request();
}

Future<void> launchInAppWebView(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      // mode: LaunchMode.e, // ✅ Opens in app
    );
  } else {
    throw "Could not launch $url";
  }
}
