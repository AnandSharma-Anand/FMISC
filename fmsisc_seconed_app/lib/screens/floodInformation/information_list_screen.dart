import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/screens/addfloodInformtaion/add_flood_controller.dart';
import 'package:untitled1/screens/addfloodInformtaion/add_flood_screen.dart';
import 'package:untitled1/screens/floodInformation/information_list_controller.dart';
import 'package:untitled1/support/app_costants.dart';

import 'information_list_model.dart';

class InformationListScreen extends StatelessWidget {
  InformationListScreen({super.key});

  InformationListController controller = Get.put(InformationListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text("Flood Data"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
        actions: [
          InkWell(
            onTap: () {
              Get.to(AddFloodScreen())!.then((value) {
                Get.delete<AddFloodController>();
              });
            },
            child: Container(
              height: 35,
              padding: EdgeInsets.symmetric(horizontal: 5),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white)),
              alignment: Alignment.center,
              child: Text('+ Add', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: controller.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }
          List<InformationListModel> infoList = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              var item = infoList[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Station: ${item.stationName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 5),
                      Text("Gauge: ${item.gauge} m", style: TextStyle(fontSize: 14)),
                      Text("Discharge: ${item.discharge} cusecs", style: TextStyle(fontSize: 14)),
                      Text("Date & Time: ${item.dataTime}", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
