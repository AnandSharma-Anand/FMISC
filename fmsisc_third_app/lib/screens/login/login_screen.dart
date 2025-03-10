import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import '../../support/app_costants.dart';
import 'LoginController.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  LoginController controller = Get.put(LoginController());

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
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(gradient: linearGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: FutureBuilder(
            future: cacheImage(context),
            builder:
                (context, snapshot) => Container(
              padding: const EdgeInsets.all(10),
              width: Get.width,
              child: SafeArea(
                child: Form(
                  key: controller.formKey,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: [
                          Image.asset('assets/logo.png', width: Get.width / 4.6).marginOnly(right: 10),
                          Text('FMISC-User Login'.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: appColor)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 50),
                        margin: EdgeInsets.all(10),
                        width: Get.width,
                        decoration: BoxDecoration(
                          gradient: linearGradient,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            // BoxShadow(color: Colors.grey.shade400, offset: const Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), //BoxShadow
                            BoxShadow(color: Colors.black26, offset: const Offset(0.0, 0.0), blurRadius: 30.0, spreadRadius: 0.5), //BoxShadow
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: FittedBox(
                                child: Text('Login into Your Account'.toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text('Email', style: TextStyle(color: appColor, fontSize: 17, fontWeight: FontWeight.w500)).marginOnly(bottom: 10),
                            TextFormField(
                              controller: controller.emailController.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                                prefixIcon: Icon(Icons.email, color: Colors.blue.shade900),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text('Password', style: TextStyle(color: appColor, fontSize: 17, fontWeight: FontWeight.w500)).marginOnly(bottom: 10),

                            Obx(
                                  () => TextFormField(
                                controller: controller.passwordController.value,
                                obscureText: controller.obscurePassword.value,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                                  suffixIcon: IconButton(
                                    icon: Icon(controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility, color: Colors.indigo),
                                    onPressed: () {
                                      controller.obscurePassword.value = !controller.obscurePassword.value;
                                    },
                                  ),
                                  prefixIcon: Icon(Icons.password, color: Colors.blue.shade900),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 4) {
                                    return 'Password must be at least 4 characters long';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                                  () =>CheckboxListTile(activeColor: appColor,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                visualDensity: VisualDensity(horizontal: -4, vertical: -4), // Reduces space
                                value: controller.isRemember.value,
                                onChanged: (value) {
                                  controller.isRemember.value = !controller.isRemember.value;
                                },
                                title: Text("Remember me"),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (controller.formKey.currentState!.validate()) {
                                  controller.loginApi();
                                }
                              },
                              child: Container(
                                height: 50,
                                width: Get.width,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: appColor,
                                  // gradient: LinearGradient(
                                  //   colors: [
                                  //     Colors.indigo.shade900,
                                  //     Colors.indigo.shade900,
                                  //     Colors.indigo.shade900,
                                  //     Colors.black54,
                                  //   ],
                                  //   begin: Alignment.topCenter,
                                  //   end: Alignment.bottomCenter,
                                  // ),
                                ),
                                alignment: Alignment.center,
                                child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
                              ).marginSymmetric(vertical: 15),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (controller.formKey.currentState!.validate()) {
                                  controller.loginApi();
                                }
                              },
                              child: Container(
                                height: 50,
                                width: Get.width,
                                margin: EdgeInsets.only(bottom: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: appColor,
                                  // gradient: LinearGradient(
                                  //   colors: [
                                  //     Colors.indigo.shade900,
                                  //     Colors.indigo.shade900,
                                  //     Colors.indigo.shade900,
                                  //     Colors.black54,
                                  //   ],
                                  //   begin: Alignment.topCenter,
                                  //   end: Alignment.bottomCenter,
                                  // ),
                                ),
                                alignment: Alignment.center,
                                child: Text('Create an account', style: TextStyle(color: Colors.white, fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
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
}
