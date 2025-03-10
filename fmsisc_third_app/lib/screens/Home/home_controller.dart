import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmsisc_third_app/support/app_costants.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:get/get.dart';
import '../../support/prefrence_manager.dart';
import '../login/login_model.dart';

class HomeController extends GetxController {
  Rx<LoginModel>? loginModel = LoginModel().obs;

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

  void uploadImage() async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator(color: appColor,)),
        barrierDismissible: false,
      );
      var headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> map = {
        if (image.value.path.isNotEmpty) 'WorkImage': await dios.MultipartFile.fromFile(image.value.path, filename: image.value.path.split('/').last),
        'UserID': loginModel!.value.id,
        'Title': titleTextController.value.text,
        'WorkDesc': suggestionTextController.value.text,
        'Latitude': '13.678',
        'Longitude': '86.378',
      };
      var data = dios.FormData.fromMap(map);
      print(map);
      var dio = Dio();
      var response = await dio.request('https://pioneersparklellc.com/api/WorkImageAPI', options: Options(method: 'POST', headers: headers), data: data);

      if (response.statusCode == 200) {
        Get.back();
        titleTextController.value.clear();
        suggestionTextController.value.clear();
        image.value = File("");
        showLongToast("Form submitted successfully!");
      } else {
        Get.back();
        print(response.statusMessage);
      }
    } on DioException catch (e) {
      Get.back();
      showLongToast("${e.response!.data?["message"]}");
      print("Server error: ${e.response!.data?["message"]}");
    } catch (e) {
      Get.back();
      showLongToast("Unexpected error: $e");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    PrefrenceManager.getLoginData().then((value) {
      print(value!.toJson());
      loginModel!.value = value!;
    });
  }
}
