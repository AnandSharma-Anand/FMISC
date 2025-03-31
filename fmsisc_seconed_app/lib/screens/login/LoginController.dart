import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:untitled1/screens/Home/home_screen.dart';
import 'package:untitled1/screens/addfloodInformtaion/add_flood_screen.dart';
import 'package:untitled1/screens/login/login_model.dart';
import 'package:untitled1/support/app_costants.dart';
import 'package:untitled1/support/prefrence_manager.dart';

class LoginController extends GetxController {
  RxBool obscurePassword = true.obs;
  RxBool isRemember = false.obs;
  var formKey = GlobalKey<FormState>();

  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLoginCredentials();
  }

  void loginApi() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showLongToast("No internet connection. Please check your network.");
      return;
    }

    var dio = Dio();
    var response = await dio.request(
      // https://pioneersparklellc.com/api/appuserapi/login?userid=user1@gmail.com&password=user
      '$baseUrl/appuserapi/login?userid=${emailController.value.text}&password=${passwordController.value.text}',
      options: Options(method: 'GET'),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = response.data;
      if (isRemember.value) {
        saveLoginCredentials();
      }
      if (map["id"] != 0) {
        map["email"] = emailController.value.text;
        map["password"] = passwordController.value.text;
        PrefrenceManager.saveLoginData(map);

        PrefrenceManager.getLoginData().then((value) {
          // Get.offAll(HomeScreen());
          Get.offAll(AddFloodScreen());
        });
      } else {
        showLongToast("Invalid email or password");
      }
    } else {
      showLongToast("There is some technical issue.\nTry again later!");
    }
  }

  saveLoginCredentials() {
    PrefrenceManager.saveString("authEmail", emailController.value.text);
    PrefrenceManager.saveString("authPassword", passwordController.value.text);
  }

  getLoginCredentials() async {
    emailController.value.text =
        (await PrefrenceManager.getString("authEmail")) ?? "";
    passwordController.value.text =
        (await PrefrenceManager.getString("authPassword")) ?? "";
  }
}
