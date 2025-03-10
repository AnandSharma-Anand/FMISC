import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../support/app_costants.dart';
import '../../support/prefrence_manager.dart';
import '../login/login_model.dart';

class AddFloodController extends GetxController {
  Rx<LoginModel>? loginModel = LoginModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    PrefrenceManager.getLoginData().then((value) {
      loginModel!.value = value!;
      print(value.runtimeType);
    });
  }

  final formKey = GlobalKey<FormState>();

  final Rx<TextEditingController> gaugeController = TextEditingController().obs;
  final Rx<TextEditingController> dischargeController = TextEditingController().obs;
  final Rx<TextEditingController> dateController = TextEditingController().obs;
  final Rx<TextEditingController> timeController = TextEditingController().obs;

  void addAPI() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showLongToast("No internet connection. Please check your network.");
      return;
    }

    var data = dios.FormData.fromMap({
      'StationID': loginModel!.value.stationID,
      'Gauge': gaugeController.value.text,
      'Discharge': dischargeController.value.text,
      'DataDate': dateController.value.text,
      'DataTime': timeController.value.text,
    });

    var dio = Dio();
    var response = await dio.request('https://pioneersparklellc.com/api/FDataAPI', options: Options(method: 'POST'), data: data);
    if (response.statusCode == 200) {
      Get.back();
    } else {
      if (kDebugMode) {
        print("⚠️ Failed to submit data: ${response.statusMessage}");
      }
      showLongToast("Submission failed! Please try again.");
    }
  }
}
