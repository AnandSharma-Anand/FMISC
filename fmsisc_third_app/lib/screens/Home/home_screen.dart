import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../support/app_costants.dart';
import '../../support/prefrence_manager.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Container(
          color: appColor,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: linearGradient),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonAppbar(),Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                      SizedBox(height: 40),
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            margin: EdgeInsets.all(10),
                            width: Get.width,
                            decoration: BoxDecoration(
                              gradient: linearGradient,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, offset: const Offset(0.0, 0.0), blurRadius: 30.0, spreadRadius: 0.5), //BoxShadow
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "Please fill out the form below with your suggestions.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18, color: appColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Form(
                                    key: homeController.formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Title"),
                                        SizedBox(height: 5),
                                        TextFormField(
                                          controller: homeController.titleTextController.value,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Title is required";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                                        ),
                                        SizedBox(height: 10),
                                        Text("Suggestions"),
                                        SizedBox(height: 5),
                                        TextFormField(
                                          controller: homeController.suggestionTextController.value,
                                          maxLines: 5,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Suggestions are required";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                                        ),
                                        SizedBox(height: 10),

                                        GestureDetector(
                                          onTap: homeController.pickImage,
                                          child: Row(
                                            children: [Icon(Icons.image, color: Colors.blue.shade900), SizedBox(width: 5), Text("Upload Image", style: TextStyle(fontSize: 16))],
                                          ),
                                        ),
                                        Obx(() {
                                          return (homeController.image!.value.path.isNotEmpty)
                                              ? Padding(padding: const EdgeInsets.only(top: 10), child: Image.file(homeController.image!.value, height: 100))
                                              : SizedBox(height: 10);
                                        }),

                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Obx(
                                                  () => Checkbox(
                                                    activeColor: appColor,
                                                value: homeController.isTermConditionChecked.value,
                                                onChanged: (value) {
                                                  homeController.isTermConditionChecked.value = !homeController.isTermConditionChecked.value;
                                                },
                                              ),
                                            ),
                                            Expanded(child: Text("I agree and accept the terms and conditions")),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade900, padding: EdgeInsets.symmetric(vertical: 15)),
                                            onPressed: () {
                                              if (homeController.formKey.currentState!.validate()) {
                                                if (homeController.image.value == null) {
                                                  Get.snackbar("Error", "Please upload an image", snackPosition: SnackPosition.BOTTOM);
                                                  return;
                                                }
                                                if (!homeController.isTermConditionChecked.value) {
                                                  Get.snackbar("Error", "You must agree to the terms and conditions", snackPosition: SnackPosition.BOTTOM);
                                                  return;
                                                }
                                                homeController.uploadImage();                                          }
                                            },
                                            child: Text("Submit", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).marginOnly(top: 35),
                          Center(child: CircleAvatar(backgroundColor: Colors.white, radius: 40, child: Icon(Icons.image_search, size: 50, color: Colors.blue.shade900))),
                        ],
                      ),],),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget commonAppbar() {
    return Container(
      color: appColor,
      width: Get.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            // padding: ,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
            child: Image.asset("assets/logo.png", height: 40).marginAll(3),
          ).marginOnly(right: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Text("FMISC APPLICATION", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)).marginOnly(top: 5)]),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              PrefrenceManager.clearPreferences();
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
