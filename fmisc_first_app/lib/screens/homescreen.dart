import 'dart:convert';

import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmsisc_first_app/screens/webview_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../support/app_costants.dart';
import 'add_suggestion/add_suggestion_screen.dart';
import 'module_model.dart';

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
        requestStoragePermission();
        //     Get.to(WebViewScreen("https://idup.gov.in/en/article/flood-bulletin-2022", "Daily Rainfall Bulletin"));
      },
    },
    {
      "img": "https://fmisc.up.gov.in/images/Icons/RTDASUP.png",
      "title": "RTDAS",
      "onTap": () {
        launchInAppWebView(Uri.parse("https://pioneersparklellc.com/report/gmapreport"));
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
        // requestPermissions();
        Get.to(WebViewScreen("https://fmisc.up.gov.in/DailyFloodBulletin/iduplink.aspx", "Daily Flood Bulletin"));
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
        // Get.to(FormScreen());
      },
    },
  ];

  // Image.asset("assets/logo.png", height: 50,),

  List<Map<String, String>> ministorsList = [
    {"img": "assets/5.png", "title": "Shri Yogi Adityanath\nHon'ble Chief Minister,\nUttar Pradesh"},
    {"img": "assets/6.png", "title": "Shri Swatantra Dev Singh\nHon'ble Cabinet Minister,\nJal Shakti, Uttar Pradesh"},
    {"img": "assets/7.png", "title": "Shri Dinesh Khateek\nHon'ble  Minister of State,\nJal Shakti, Uttar Pradesh"},
    {"img": "assets/8.png", "title": "Shri Ramkesh Nishad\nHon'ble  Minister of State,\nJal Shakti, Uttar Pradesh"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool isFileUrl(String url) {
    final fileExtensions = ['pdf', 'jpg', 'png', 'mp4', 'docx', 'xlsx']; // Add more as needed
    Uri uri = Uri.parse(url);
    String path = uri.path.toLowerCase();

    return fileExtensions.any((ext) => path.endsWith(".$ext"));
  }

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
                      FutureBuilder(
                        future: fetchModulesFromApi(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text("No Modules Available"));
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(snapshot.data!.length, (index) {
                                  Module module = snapshot.data![index];
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      if (isFileUrl(module.webURL)) {
                                        await launchUrl(Uri.parse(module.webURL), mode: LaunchMode.inAppBrowserView);
                                      } else if (isSecureUrl(module.webURL)) {
                                        await launchUrl(Uri.parse(module.webURL), mode: LaunchMode.inAppBrowserView);
                                      } else if ((snapshot.data!.length - 1) == index) {
                                        Get.to(SuggestionForm());
                                      } else {
                                        Get.to(WebViewScreen(module.webURL, module.title));
                                      }
                                    },
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
                                                imageUrl: module.imageURL,

                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.contain))),
                                                placeholder: (context, url) => const Padding(padding: EdgeInsets.all(18.0), child: CircularProgressIndicator()),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3),
                                            child: Text(module.title, maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }
                        },
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
                              child: AutoHeightGridView(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ministorsList.length,
                                builder: (BuildContext context, int index) {
                                  return Container(
                                    // decoration: BoxDecoration(
                                    //   border: Border.all(color: appColor, width: 2),
                                    //   gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade50], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                    // ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Image.asset(
                                  ministorsList[index]['img']!, // Access the asset path
                                    fit: BoxFit.cover,
                                    height: 160,
                                    width: 180,
                                  ),
                                        ),
                                        // Text(ministorsList[index]['title']!, textAlign: TextAlign.center,maxLines: 3,),
                                      ],
                                    ),
                                  );
                                },
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

  bool isSecureUrl(String url) {
    Uri uri = Uri.parse(url);
    print(uri.scheme);
    return uri.scheme == "http";
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
          /* IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),*/
        ],
      ),
    );
  }

  Future<List<Module>> fetchModulesFromApi() async {
    try {
      var dio = Dio();
      dios.Response response = await dio.get('https://pioneersparklellc.com/api/AppUserAPI/WebView');
      Map<String, dynamic> jsonResponse = response.data;
      jsonResponse["data"].add({"title": "Suggestion Form", "webURL": "", "imageURL": "https://fmisc.up.gov.in/images/Icons/hydrometStatus.png"});
      ResponseModel responseModel = ResponseModel.fromJson(jsonResponse);

      return responseModel.data;
    } catch (e, str) {
      print(e);
      print(str);
      return [];
    }
  }
}
