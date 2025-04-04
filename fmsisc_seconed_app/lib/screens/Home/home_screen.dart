import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:untitled1/screens/Home/home_controller.dart';
import 'package:untitled1/support/prefrence_manager.dart';

import '../../support/app_costants.dart';
import '../floodInformation/information_list_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: appColor),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: appColor),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(gradient: linearGradient),
              child: ListView(
                children: [
                  commonAppbar(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(color: appColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                            child: Obx(
                              () => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
                                child: Text(
                                  homeController.loginModel!.value.data?.role.toString() == "Contributor"
                                      ? "Station : ${homeController.loginModel!.value.data?.stationName.toString()}"
                                      : "${(homeController.loginModel!.value.data?.role ?? "").toString()} Dashboard",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          (homeController.loginModel!.value.data?.role ?? "").toString() != "Contributor" ? contributerMenu() : adminMenu(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contributerMenu() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(InformationListScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add/View Flood Information", maxLines: 1, style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.grey, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.orange.shade50),
                              child: Icon(Icons.group_outlined, size: 25, color: Colors.red),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Flood Information Data",
                                    maxLines: 2,
                                    style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text("View Information...", style: TextStyle(color: Colors.blue.shade700, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("View Gauge Discharge in", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.green.shade50),
                            child: Icon(Icons.map, size: 25, color: Colors.green),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Google Station Report",
                                  maxLines: 2,
                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text("View Map...", style: TextStyle(color: Colors.blue.shade700, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("View 5 days water level", maxLines: 1, style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue.shade50),
                            child: Icon(Icons.water_outlined, size: 25, color: Colors.blue),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Station Water Level Chart",
                                  maxLines: 2,
                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text("View Information...", style: TextStyle(color: Colors.blue.shade700, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("View Daily Flood Bulletin", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.deepPurple.shade50),
                            child: Icon(Icons.graphic_eq, size: 25, color: Colors.deepPurple),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Daily Flood Bulletin Report",
                                  maxLines: 2,
                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text("View Report...", style: TextStyle(color: Colors.blue.shade700, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget adminMenu() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User Count", maxLines: 1, style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.orange.shade50),
                            child: Icon(Icons.group_outlined, size: 25, color: Colors.orange),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total 30 Users",
                                  maxLines: 2,
                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.blue.shade900, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Station Count", style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.green.shade50),
                            child: Icon(Icons.map, size: 25, color: Colors.green),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total 24 Stations",
                                  maxLines: 2,
                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.blue.shade900, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("River Count", maxLines: 1, style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue.shade50),
                            child: Icon(Icons.water_outlined, size: 25, color: Colors.blue),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total 9\nRivers",
                                  maxLines: 2,
                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.blue.shade900, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("District Count", style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.deepPurple.shade50),
                            child: Icon(Icons.graphic_eq, size: 25, color: Colors.deepPurple),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total 18 District",
                                  maxLines: 2,
                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.blue.shade900, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget commonAppbar() {
    return Container(
      color: appColor,
      width: Get.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(color: Colors.white, child: Image.asset("assets/logo.png", height: 40)).marginOnly(right: 20),
          Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "FMISC ${(homeController.loginModel!.value.data?.role).toString().capitalizeFirst.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                    ).marginOnly(top: 5),
                  ],
                ),
              ],
            ),
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
