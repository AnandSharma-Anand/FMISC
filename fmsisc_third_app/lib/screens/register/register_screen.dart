import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fmsisc_third_app/screens/register/register_controller.dart';
import 'package:fmsisc_third_app/screens/register/register_screen.dart';
import 'package:get/get.dart';

import '../../support/app_costants.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  RegisterController registerController = Get.put(RegisterController());

  Future<void> cacheImage(BuildContext context) async {
    final cacheManager = DefaultCacheManager();
    await cacheManager.putFile('assets/master_background.png', (await DefaultAssetBundle.of(context).load('assets/master_background.png')) as Uint8List);
    await cacheManager.putFile('assets/up_govt.png', (await DefaultAssetBundle.of(context).load('assets/up_govt.png')) as Uint8List);
    await cacheManager.putFile('assets/logo.png', (await DefaultAssetBundle.of(context).load('assets/logo.png')) as Uint8List);
    await cacheManager.putFile('assets/map.png', (await DefaultAssetBundle.of(context).load('assets/map.png')) as Uint8List);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Container(
        color: appColor,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(gradient: linearGradient),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: FutureBuilder(
                future: cacheImage(context),
                builder:
                    (context, snapshot) => Form(
                      key: registerController.formKey,
                      child: ListView(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(color: appColor),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(02),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: Image.asset('assets/logo.png', width: Get.width / 7.5),
                                ).marginOnly(left: 10, bottom: 5),
                                Spacer(),
                                Text('FMISC Application'.toString().toUpperCase(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),

                                Spacer(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                margin: EdgeInsets.all(10),
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: linearGradient,

                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.shade400, offset: const Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), //BoxShadow
                                    BoxShadow(color: Colors.white, offset: const Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.0), //BoxShadow
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 25),
                                    FittedBox(
                                      child: Text(
                                        'Login to your account'.capitalizeFirst.toString(),
                                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    Obx(() {
                                      return DropdownButtonFormField<String>(
                                        value: registerController.selectedStation,
                                        decoration: textFieldDecoration(labelText: 'Station ID'),
                                        items:
                                            registerController.stations.map<DropdownMenuItem<String>>((station) {
                                              return DropdownMenuItem<String>(value: station['id'].toString(), child: Text(station['stationName'] ?? "aa"));
                                            }).toList(),
                                        onChanged: (value) {
                                          registerController.selectedStation = value;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a station';
                                          }
                                          return null;
                                        },
                                      );
                                    }),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: registerController.fullNameController.value,
                                      decoration: textFieldDecoration(labelText: 'Full Name'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your full name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: registerController.mobileController.value,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                                      decoration: textFieldDecoration(labelText: 'Mobile No'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value.length != 10) {
                                          return 'Enter a valid 10-digit mobile number';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: registerController.emailController.value,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: textFieldDecoration(labelText: 'Email'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                          return 'Enter a valid email address';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: registerController.passwordController.value,
                                      obscureText: true,
                                      decoration: textFieldDecoration(labelText: 'Password'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a password';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        if (registerController.formKey.currentState!.validate()) {
                                          registerController.registerUser();
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          gradient: LinearGradient(
                                            colors: [Colors.indigo.shade900, Colors.indigo.shade900, Colors.indigo.shade900, Colors.black54],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 20)),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Already Registered? Login",style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ],
                                ),
                              ).marginOnly(top:40),
                              Center(child: CircleAvatar(backgroundColor: Colors.white, radius: 40, child: Icon(Icons.app_registration, size: 50, color: Colors.blue.shade900))),

                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  textFieldDecoration({String? labelText}) {
    return InputDecoration(
      labelText: labelText,

      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
    );
  }
}
