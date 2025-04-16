import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fmsisc_third_app/screens/homescreen.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../support/app_costants.dart';
import '../../support/prefrence_manager.dart';
import '../add_suggestion/add_suggestion_screen.dart';

class LoginController extends GetxController {
  RxBool obscurePassword = true.obs;
  RxBool isRemember = false.obs;
  var formKey = GlobalKey<FormState>();

  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController = TextEditingController().obs;

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

    Get.dialog(Center(child: CircularProgressIndicator(color: appColor)), barrierDismissible: false);

    var dio = Dio();
    // String url = 'https://pioneersparklellc.com/api/UserLoginAPI?emailaddress=${emailController.value.text}&password=${passwordController.value.text}';
    String url = 'https://pioneersparklellc.com/api/appuserapi/palogin?userid=${emailController.value.text}&password=${passwordController.value.text}';
    print(url);

    try {

      var response = await dio.request(url, options: Options(method: 'GET'));

      if (response.statusCode == 200) {
        Get.back(); // Close the loader pop-up

        Map<String, dynamic> map = response.data;
        print(map);
        if (map["success"] == true) {
          if (isRemember.value) {
            saveLoginCredentials();
          }
          if (map["id"] != 0) {
            map["data"]["email"] = emailController.value.text;
            map["data"]["password"] = passwordController.value.text;
            PrefrenceManager.saveLoginData(map["data"]);

            PrefrenceManager.getLoginData().then((value) {
              // Get.offAll(HomeScreen());
              Get.offAll(FormScreen());
            });
          } else {
            showLongToast(map["message"]);
          }
        } else {

          showLongToast("Invalid email or password");
        }
      }
    } on DioException catch (e) {
      Get.back(); // Close the loader pop-up

      if (e.response != null && e.response!.statusCode == 400) {
        String errorMessage = e.response!.data?["message"] ?? "Invalid request. Please check your details.";
        showLongToast(errorMessage);
      } else {
        showLongToast("There is some technical issue.\nTry again later! \n Status Code : ${e.response?.statusCode}");
      }
    } catch (e) {
      Get.back(); // Close the loader pop-up

      showLongToast("Unexpected error: $e");
    } finally {
      Get.back(); // Close the loader pop-up
    }
  }

  saveLoginCredentials() {
    PrefrenceManager.saveString("authEmail", emailController.value.text);
    PrefrenceManager.saveString("authPassword", passwordController.value.text);
  }

  getLoginCredentials() async {
    emailController.value.text = (await PrefrenceManager.getString("authEmail")) ?? "";
    passwordController.value.text = (await PrefrenceManager.getString("authPassword")) ?? "";
  }
}
