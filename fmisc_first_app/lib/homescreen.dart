import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmsisc_third_app/suggestion_form.dart';
import 'package:get/get.dart';

import 'constanDatas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> menuList = [
    {"img": "https://fmisc.up.gov.in/images/Icons/Dailyrainfallbulletin.png", "title": "Daily Rainfall Bulletin", "onTap": () {}},
    {"img": "https://fmisc.up.gov.in/images/Icons/RTDASUP.png", "title": "RTDAS", "onTap": () {}},
    {"img": "https://fmisc.up.gov.in/images/Icons/InundationMap.png", "title": "Inundation Map", "onTap": () {}},
    {"img": "https://fmisc.up.gov.in/images/Icons/floodbulletindaily.png", "title": "Daily Flood Bulletin", "onTap": () {}},
    {"img": "https://fmisc.up.gov.in/images/Icons/embadvisory.png", "title": "Embankment Advisory", "onTap": () {}},
    {
      "img": "https://fmisc.up.gov.in/images/Icons/hydrometStatus.png",
      "title": "Suggestion Form",
      "onTap": () {
        Get.to(const SuggestionForm());
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
          child: Column(
            children: [
              commonAppbar(),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(menuList.length, (index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            onTap: menuList[index]["onTap"],
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: appColor, width: 3), borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CachedNetworkImage(
                                      imageUrl: menuList[index]['img']!,
                                      height: 100,
                                      width: 100,
                                      imageBuilder:
                                          (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                                      placeholder: (context, url) => const Padding(padding: EdgeInsets.all(18.0), child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                  Text(menuList[index]['title']!, textAlign: TextAlign.center),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(blurRadius: 2.0, spreadRadius: 1.0), //BoxShadow
                          //BoxShadow
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            color: appColor,
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
                                  decoration: BoxDecoration(border: Border.all(color: appColor, width: 2), borderRadius: BorderRadius.circular(10)),
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
    );
  }
}
