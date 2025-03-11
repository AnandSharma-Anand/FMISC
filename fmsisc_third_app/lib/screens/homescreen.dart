import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmsisc_third_app/screens/webview_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../support/app_costants.dart';
import '../support/prefrence_manager.dart';
import 'add_suggestion/add_suggestion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> menuList = [
    {
      "img": "https://fmisc.up.gov.in/images/Icons/Dailyrainfallbulletin.png",
      "title": "Daily Rainfall Bulletin",
      "onTap": () {
        Get.to(WebViewScreen("https://pioneersparklellc.com/report/gmapreport", "Daily Rainfall Bulletin"));
      },
    },
    {
      "img": "https://fmisc.up.gov.in/images/Icons/RTDASUP.png",
      "title": "RTDAS",
      "onTap": () {
        launchInAppWebView(Uri.parse("https://pioneersparklellc.com/report/gmapreport"));
        // Get.to(WebViewScreen("https://pioneersparklellc.com/report/gmapreport", "RTDAS"));

      },
    },
    {
      "img": "https://fmisc.up.gov.in/images/Icons/InundationMap.png",
      "title": "Inundation Map",
      "onTap": () {
        Get.to(WebViewScreen("https://pioneersparklellc.com/report/gmapreport", "Inundation Map"));
      },
    },
    {
      "img": "https://fmisc.up.gov.in/images/Icons/floodbulletindaily.png",
      "title": "Daily Flood Bulletin",
      "onTap": () {
        Get.to(WebViewScreen("https://www.google.com/", "Daily Flood Bulletin"));
      },
    },
    {
      "img": "https://fmisc.up.gov.in/images/Icons/embadvisory.png",
      "title": "Embankment Advisory",
      "onTap": () {
        Get.to(WebViewScreen("https://www.google.com/", "Embankment Advisory"));
      },
    },
    {
      "img": "https://fmisc.up.gov.in/images/Icons/hydrometStatus.png",
      "title": "Suggestion Form",
      "onTap": () {
        Get.to(AddSuggestionForm());
      },
    },
  ];

  List<Map<String, String>> ministorsList = [
    {"img": "https://fmisc.up.gov.in/images/headerimages/cm.jpg", "title": "Shree Yogi Adityanath\nHon'ble Chief Minister,\nUttar Pradesh"},
    {"img": "https://fmisc.up.gov.in/images/headerimages/Swatantra.jpg", "title": "Shri Swatantra Dev Singh\nHon'ble Cabinet Minister,\nJal Shakti, Uttar Pradesh"},
    {"img": "https://fmisc.up.gov.in/images/headerimages/DineshKhateek.jpg", "title": "Shri Dinesh Khateek\nHon'ble  Minister of State,\nJal Shakti, Uttar Pradesh"},
    {"img": "https://fmisc.up.gov.in/images/headerimages/Ramkesh.jpg", "title": "Shri Ramkesh Nishad\nHon'ble  Minister of State,\nJal Shakti, Uttar Pradesh"},
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: appColor),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(gradient: linearGradient),
            child: Column(
              children: [
                commonAppbar(),
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(menuList.length, (index) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: menuList[index]["onTap"],
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade50], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                  border: Border.all(color: appColor, width: 3),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CachedNetworkImage(
                                          imageUrl: menuList[index]['img']!,
                                          /*  height: 70,
                                          width: 70,*/
                                          imageBuilder:
                                              (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.contain))),
                                          placeholder: (context, url) => const Padding(padding: EdgeInsets.all(18.0), child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3),
                                      child: Text(menuList[index]['title']!, maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: appColor),

                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Hon'ble Ministers".toString().capitalize.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(ministorsList.length, (index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: appColor, width: 2),
                                      gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade50], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: CachedNetworkImage(
                                            imageUrl: ministorsList[index]['img']!,
                                            height: 100,
                                            width: 100,
                                            imageBuilder:
                                                (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                        Text(ministorsList[index]['title']!, textAlign: TextAlign.center),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
