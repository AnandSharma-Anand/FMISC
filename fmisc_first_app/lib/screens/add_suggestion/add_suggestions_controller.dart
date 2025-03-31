import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fmsisc_first_app/support/app_costants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:get/get.dart';
import 'add_suggestion_screen.dart';

class AddSuggestioController extends GetxController {
  RxBool isTermConditionChecked = false.obs;

  Rx<TextEditingController> titleTextController = TextEditingController().obs;
  Rx<TextEditingController> suggestionTextController = TextEditingController().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form key

  Rx<File> image = File("").obs;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.back();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.back();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.back();
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void uploadImage() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        showLongToast("No internet connection. Please check your network.");
        return;
      }
      Get.dialog(Center(child: CircularProgressIndicator(color: appColor)), barrierDismissible: false);

      Position position = await _determinePosition();

      var headers = {'Content-Type': 'application/json'};
      List<String> listString = (image.value.path.split('/').last).toString().split(".");
      String fileName = "${DateTime.now()}${listString.first}";
      Map<String, dynamic> map = {
        if (image.value.path.isNotEmpty) 'WorkImage': await dios.MultipartFile.fromFile(image.value.path, filename: image.value.path.split('/').last),
        'UserID': 0,
        'Title': titleTextController.value.text,
        'WorkDesc': suggestionTextController.value.text,
        'Latitude': position.latitude,
        'Longitude': position.longitude,
      };

      var data = dios.FormData.fromMap(map);
      print(map);
      var dio = Dio();
      var response = await dio.request('https://pioneersparklellc.com/api/WorkImageAPI', options: Options(method: 'POST', headers: headers), data: data);
      print("aaaaaa${response.statusCode}");
      if (response.statusCode == 200) {
        Get.back();
        titleTextController.value.clear();
        suggestionTextController.value.clear();
        image.value = File("");
        isTermConditionChecked.value = false;
        showLongToast("Form submitted successfully!");
      } else {
        Get.back();
        print(response.statusMessage);
      }
    } on DioException catch (e) {
      if (Get.isDialogOpen ?? true) {
        Get.back();
      }
      showLongToast("${e.response!.data}");
      print("Server error: ${e.response!.data}");
    } catch (e, str) {
      Get.back();
      print(e);
      print(str);
      showLongToast("Unexpected error: $e");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
