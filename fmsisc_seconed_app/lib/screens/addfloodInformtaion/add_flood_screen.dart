import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/screens/addfloodInformtaion/unapproved_data.dart';

import '../../support/app_costants.dart';
import 'add_flood_controller.dart';

class AddFloodScreen extends StatelessWidget {
  AddFloodScreen({super.key});

  AddFloodController addFloodController = Get.put(AddFloodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Obx(() => Text("Station : ${addFloodController.loginModel!.value.data?.stationName ?? ''}")),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Form(
            key: addFloodController.formKey, // Attach form key
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: addFloodController.gaugeController.value,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Gauge',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter gauge";
                      }
                      double? input = double.tryParse(value);
                      if (input == null) return "Invalid number";
                      if (input > addFloodController.maxFloodLevel.value) return "Gauge cannot exceed ${addFloodController.maxFloodLevel.value}";
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: addFloodController.dischargeController.value,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Discharge',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Discharge";
                      }
                      double? input = double.tryParse(value);
                      if (input == null) return "Invalid number";
                      if (input > addFloodController.maxDischarge.value) return "Discharge cannot exceed ${addFloodController.maxDischarge.value}";
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    // Date Dropdown
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          value: addFloodController.dateController.value.text.isEmpty ? null : addFloodController.dateController.value.text,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                          ),
                          items: [
                            DropdownMenuItem(value: _formattedDate(DateTime.now()), child: Text(_formattedDate(DateTime.now()))),
                            DropdownMenuItem(
                              value: _formattedDate(DateTime.now().subtract(Duration(days: 1))),
                              child: Text(_formattedDate(DateTime.now().subtract(Duration(days: 1)))),
                            ),
                          ],
                          onChanged: (value) {
                            addFloodController.dateController.value.text = value!;
                          },
                          validator: (value) => value == null ? 'Select a date' : null,
                        ),
                      ),
                    ),
                    // Time Dropdown
                    Obx(
                      () => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                            value: addFloodController.timeController.value.text.isEmpty ? null : addFloodController.timeController.value.text,
                            decoration: InputDecoration(
                              labelText: 'Time',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                            ),
                            items:
                                addFloodController.timeSlots.map((time) {
                                  return DropdownMenuItem(value: time, child: Text(time));
                                }).toList(),
                            onChanged: (value) {
                              addFloodController.timeController.value.text = value!;
                            },
                            validator: (value) => value == null ? 'Select a time' : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Submit Button
                GestureDetector(
                  onTap: () {
                    if (addFloodController.formKey.currentState!.validate()) {
                      addFloodController.addAPI();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: Get.width,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade700,
                          Colors.blue.shade700,
                          Colors.blue.shade700,
                          // Colors.blue.shade900,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => FutureBuilder<List<UnapprovedData>>(
              future: addFloodController.fetchUnapprovedData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return (Get.isDialogOpen!)?SizedBox():Center(child: CircularProgressIndicator()); // Loading state
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}")); // Error state
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No data available")); // Empty state
                }

                List<UnapprovedData> dataList = snapshot.data!;
                return ListView.builder(
                  itemCount: dataList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    UnapprovedData data = dataList[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 3,
                      child: ListTile(
                        title: Text("Station: ${data.stationName}", style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Gauge: ${data.gauge}, Discharge: ${data.discharge}"),
                        trailing: Text(data.dataTime),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Function to format the date as "dd-MM-yyyy"
  String _formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
    //return "${date.day}-${date.month}-${date.year}";
  }

  /// Function to generate time slots from 4 AM to 12 AM (every 4 hours)
  List<String> _generateTimeSlots() {
    List<String> timeSlots = [];
    for (int hour = 4; hour <= 24; hour += 4) {
      String formattedHour = hour.toString().padLeft(2, '0');
      timeSlots.add("$formattedHour:00");
    }
    return timeSlots;
  }
}
