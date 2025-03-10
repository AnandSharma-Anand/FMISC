import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/screens/login/login_screen.dart';

import '../screens/login/login_model.dart';

class PrefrenceManager {
  static Future<void> saveLoginData(Map value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("authData", jsonEncode(value));
  }
  static Future<LoginModel?> getLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString("authData");
    print(jsonString);
    if (jsonString == null) return null;
    return LoginModel.fromJson(jsonDecode(jsonString));
  }

  static Future<void> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }


  static clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("authData");
    Get.deleteAll();
    Get.offAll(LoginScreen());
  }



}
