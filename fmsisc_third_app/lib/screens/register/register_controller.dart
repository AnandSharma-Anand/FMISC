import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:flutter/material.dart';
import 'package:fmsisc_third_app/support/app_costants.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxList<dynamic> stations = [].obs;
  String? selectedStation;
  final formKey = GlobalKey<FormState>();

  final Rx<TextEditingController> fullNameController = TextEditingController().obs;
  final Rx<TextEditingController> mobileController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController = TextEditingController().obs;
  final Rx<TextEditingController> isActiveController = TextEditingController().obs;

  Future<void> fetchStations() async {
    try {
      var response = await Dio().get('https://pioneersparklellc.com/api/StationAPI');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = response.data;
        stations.value = responseMap["data"];
        if (stations.isNotEmpty) {
          selectedStation = stations.first['id'].toString();
        }
      }
    } catch (e) {
      print("Error fetching stations: $e");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchStations();
  }

  Future<void> registerUser() async {
    if (formKey.currentState!.validate()) {
      try {
        var dio = Dio();
        var response = await dio.post(
          "https://pioneersparklellc.com/api/UserLoginAPI",
          options: Options(headers: {"Content-Type": "application/json"}),
          data: dios.FormData.fromMap({
            "StationID": selectedStation,
            "FullName": fullNameController.value.text,
            "MobileNo": mobileController.value.text,
            "Email": emailController.value.text,
            "Password": passwordController.value.text,
            "IsActive": isActiveController.value.text,
          }),
        );
        print(response);
        if (response.statusCode == 200) {
          showDialog(
            context: Get.overlayContext!,
            builder:
                (context) => AlertDialog(
                  title: Text("Account Verification"),
                  content: Text("Registration successful! Your account is under verification. Please wait for approval."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Get.delete<RegisterController>();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
          );
         // showLongToast("Registration Successful!");
        } else {
          showLongToast("Registration Failed!");
        }
      } catch (e, str) {
        print(str);
        print("Error: $e");
      }
    }
  }
}
