import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/screens/addfloodInformtaion/unapproved_data.dart';

import '../../support/app_costants.dart';
import '../../support/prefrence_manager.dart';
import '../login/login_model.dart';
import 'add_flood_screen.dart';

class AddFloodController extends GetxController {
  Rx<LoginModel>? loginModel = LoginModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("initilizeing add flood");

    PrefrenceManager.getLoginData().then((value) {
      loginModel!.value = value!;
      fetchData(loginModel!.value.data?.stationID);
      fetchTimeSlot();

      print(value.toJson());
    });
  }

  onEdit(UnapprovedData data) {
    try {
      gaugeController.value.text = (data.gauge ?? "").toString();
      dischargeController.value.text = (data.discharge ?? "").toString();
      List<String> list = data.dataTime.split(" ");
      // dateController.value.text = list.first;

     int indexx= timeSlots.indexWhere((element) {
       print(element);
       print(list[list.length-2]+" "+list.last);
       return  element == "${list[list.length-2]} ${list.last}";
     });
print(indexx);
     if(indexx!=-1){
       timeController.value.text = timeSlots[indexx];
     }
    } catch (e, str) {}
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
    Get.dialog(Center(child: CircularProgressIndicator(color: appColor)), barrierDismissible: false);

    Map<String, dynamic> requestMap = {
      'StationID': loginModel!.value.data?.stationID,
      'Gauge': gaugeController.value.text,
      'Discharge': dischargeController.value.text,
      'DataDate': dateController.value.text,
      'DataTime': timeController.value.text,
    };
    var data = dios.FormData.fromMap(requestMap);
    print(requestMap);
    var dio = Dio();
    var response = await dio.request('https://pioneersparklellc.com/api/appstationapi/postflooddata', options: Options(method: 'POST'), data: data);
    print(response.data);
    Get.back();

    if (response.statusCode == 200) {
      showLongToast("Submission success....");
      Get.deleteAll();
      Get.offAll(AddFloodScreen());
    } else {
      showLongToast("Submission failed! Please try again.");
    }
  }

  RxDouble maxFloodLevel = 0.0.obs;
  RxDouble maxDischarge = 0.0.obs;

  void fetchData(String? stationID) async {
    Get.dialog(Center(child: CircularProgressIndicator(color: appColor)), barrierDismissible: false);

    final Dio dio = Dio();
    String url = "https://pioneersparklellc.com/api/appstationapi/validatefdata?stationid=$stationID";

    try {
      var response = await dio.get(url);
      Get.back();
      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> jsonData = response.data;
        String rawData = jsonData["data"];
        rawData = rawData.replaceAll("{", "{\"").replaceAll(":", "\":").replaceAll(",", ",\"").replaceAll(" ", "");
        Map<String, dynamic> parsedData = jsonDecode(rawData);

        maxFloodLevel.value = double.parse(parsedData["maxFloodLevel"].toString());
        maxDischarge.value = double.parse(parsedData["maxDischarge"].toString());
      } else {}
    } catch (e, str) {
      Get.back();
    }
  }

  RxList<String> timeSlots = <String>[].obs;

  void fetchTimeSlot() async {
    Get.dialog(Center(child: CircularProgressIndicator(color: appColor)), barrierDismissible: false);

    final Dio dio = Dio();
    String url = "https://pioneersparklellc.com/api/appstationapi/timeslot";

    try {
      var response = await dio.get(url);
      print(response.data);
      Get.back();
      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> jsonData = response.data;
        jsonData["data"].forEach((element) {
          timeSlots.add(element);
        });

        print(timeSlots);
      } else {}
    } catch (e, str) {
      Get.back();
      print("Request failed: $e");
      print("Request failed: $str");
    }
  }

  /*void fetchUnapprovedData(String? stationID) async {
    final Dio dio = Dio();
    String url = "https://pioneersparklellc.com/api/AppStationAPI/GetUnApprovedData?StationID=$stationID";

    try {
      var response = await dio.get(url);
      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> jsonData = response.data;
      }
    } catch (e, str) {
      print("Request failed: $e");
      print("Request failed: $str");
    }
  }*/
  Future<List<UnapprovedData>> fetchUnapprovedData() async {
    try {
      String apiUrl = "https://pioneersparklellc.com/api/AppStationAPI/GetUnApprovedData?StationID=${loginModel!.value.data?.stationID}";

      final Dio _dio = Dio();
      var response = await _dio.get(apiUrl);
      print(response.data);
      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> jsonList = response.data['data']; // Extract "data" array
        return jsonList.map((json) => UnapprovedData.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
}
