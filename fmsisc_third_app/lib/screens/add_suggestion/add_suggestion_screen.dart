import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../support/app_costants.dart';
import '../../support/prefrence_manager.dart';
import 'add_suggestions_controller.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddSuggestionForm extends StatelessWidget {
  AddSuggestionForm({super.key});

  AddSuggestioController homeController = Get.put(AddSuggestioController());

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
                  commonAppbar(),

                  Expanded(child: FormScreen()),

                  /*     Expanded(
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
                                                  homeController.uploadImage();
                                                }
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
                        ),
                      ],
                    ),
                  ),*/
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
              Get.delete<AddSuggestioController>();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text("Suggestion Form", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
          Spacer(),
        ],
      ),
    );
  }
}

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String? selectedYear;
  String? selectedRiver;
  String? selectedRiverSide;
  String? selectedDistrict;
  String? selectedSangathan;
  String? selectedCircle;
  String? selectedDivision;

  String? selectedFile; // File selection placeholder

  List<Map<String, dynamic>> years = [];
  List<Map<String, dynamic>> rivers = [];
  List<Map<String, dynamic>> riversSide = [
    {"value": "Left", "label": "Left"},
    {"value": "Right", "label": "Right"},
  ];
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> sangathans = [];
  List<Map<String, dynamic>> circles = [];
  List<Map<String, dynamic>> divisions = [];

  final TextEditingController blockController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form Key for validation

  @override
  void initState() {
    super.initState();
    fetchYears();
    fetchRivers();
    fetchDistricts();
    fetchSangathans();
  }

  Future<void> fetchDropdownData(String url, List<Map<String, dynamic>> targetList, {String? DataID}) async {
    try {
      final response = await http.get(Uri.parse(url + (DataID ?? "")));
      print(url);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["success"] == true) {
          targetList.clear();
          setState(() {
            jsonData["data"].forEach((item) {
              if (item.runtimeType == String) {
                targetList.add({"value": item, "label": item});
              } else {
                targetList.add(item);
              }
            });
          });
          print(targetList);
        }
      }
    } catch (e, str) {
      print("Error fetching data from $url: $e : $str");
    }
  }

  void fetchYears() async {
    await fetchDropdownData('https://pioneersparklellc.com/api/AppPhotoAPI/YearDDL', years);
  }

  void fetchRivers() async {
    await fetchDropdownData('https://pioneersparklellc.com/api/AppPhotoAPI/GetRiverDDL', rivers);
  }

  void fetchDistricts() async {
    await fetchDropdownData('https://pioneersparklellc.com/api/AppStationAPI/GetDistrictDDL', districts);
  }

  void fetchSangathans() async {
    await fetchDropdownData('https://pioneersparklellc.com/api/AppStationAPI/GetSangathanDDL', sangathans);
  }

  void fetchCircles(String sangathan) async {
    await fetchDropdownData('https://pioneersparklellc.com/api/AppStationAPI/GetCircleDDL', circles, DataID: "?ID=$sangathan");
  }

  void fetchDivisions(String circles) async {
    await fetchDropdownData('https://pioneersparklellc.com/api/AppStationAPI/GetDivisionDDL', divisions, DataID: "?ID=$circles");
  }

  Widget buildDropdown(String label, List<Map<String, dynamic>> items, String? selectedItem, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedItem,

      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.red,

      isExpanded: true,
      style: TextStyle(color: Colors.red, fontSize: 16),
      items:
          items.map((item) {
            List<String> keys = item.keys.toList();
            return DropdownMenuItem(
              value: item[keys.first].toString(),
              child: Text(
                item[keys.last] ?? 'sss', // Display the station name
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black), // Make sure text is visible
              ),
            );
          }).toList(),
      onChanged: (value) {
        onChanged(value);
        print("Selected $label: $value");
      },
      validator: (value) => value == null ? "Please select $label" : null,
      hint: Text(items.isEmpty ? "Loading..." : "Select $label", style: TextStyle(color: Colors.grey)),
    ).marginOnly(top: 10);
  }

  AddSuggestioController homeController = Get.put(AddSuggestioController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: appColor),
      child: Scaffold(
        body: Container(
          color: appColor,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: linearGradient),
              child: Column(
                children: [
                  commonAppbar(),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          shrinkWrap: true,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDropdown('Select Year', years, selectedYear, (value) {
                              setState(() {
                                selectedYear = value;
                              });
                            }),
                            SizedBox(height: 10),
                            buildDropdown('River Name', rivers, selectedRiver, (value) {
                              setState(() {
                                selectedRiver = value;
                                print(selectedRiver);
                              });
                            }),
                            SizedBox(height: 10),
                            buildDropdown('River Side', riversSide, selectedRiverSide, (value) {
                              setState(() {
                                selectedRiverSide = value;
                              });
                            }),
                            SizedBox(height: 10),
                            buildDropdown('District', districts, selectedDistrict, (value) {
                              setState(() {
                                selectedDistrict = value;
                              });
                            }),
                            SizedBox(height: 10),
                            buildTextField("Block", blockController),
                            buildTextField("Village", villageController),
                            buildDropdown('Sangathan Name', sangathans, selectedSangathan, (value) {
                              setState(() {
                                selectedSangathan = value;
                                fetchCircles(selectedSangathan!);
                              });
                            }),
                            SizedBox(height: 10),
                            buildDropdown('Circle Name', circles, selectedCircle, (value) {
                              setState(() {
                                selectedCircle = value;
                                fetchDivisions(selectedCircle!);
                              });
                            }),
                            SizedBox(height: 10),
                            buildDropdown('Division Name', divisions, selectedDivision, (value) {
                              setState(() {
                                selectedDivision = value;
                              });
                            }),
                            SizedBox(height: 10),
                            buildTextField("Title", titleController),
                            Text("Upload Image:", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: homeController.pickImage,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      backgroundColor: Colors.grey,
                                      minimumSize: Size(150, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12), // Set border radius
                                      ),
                                    ),
                                    child: Obx(
                                      () => Text(homeController.image.value.path.trim().isEmpty ? "Take a photo" : "Re-take Photo", style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 5,
                                  child: Obx(
                                    () => Text(
                                      homeController.image.value.path.trim().isEmpty ? "No File Chosen" : homeController.image.value.path.split('/').last,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            GestureDetector(
                              onTap: _submitForm,
                              child: Container(
                                height: 50,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: appColor,
                                ),
                                alignment: Alignment.center,
                                child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 18)),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
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

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
        decoration: InputDecoration(fillColor: Colors.white, filled: true, labelText: label, border: OutlineInputBorder(), labelStyle: TextStyle(color: Colors.black54)),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (homeController.image.value.path.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a file")));
        return;
      }
      homeController.uploadData(
        title: titleController.text,
        riverID: selectedRiver??"",
        districtId: (selectedDistrict ?? "").toString(),
        block: blockController.text,
        village: villageController.text,
        riverSide: selectedRiverSide ?? '',
        sangathanID: selectedSangathan ?? '',
        circleID: selectedCircle ?? '',
        divisionID: selectedDivision ?? '',
      );
    }
  }

  Widget commonAppbar() {
    return Container(
      color: appColor,
      width: Get.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
              Get.delete<AddSuggestioController>();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text("Suggestion Form", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
          Spacer(),

          /// 🔹 **Popup Menu**
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white), // 3-dot menu icon
            onSelected: (String value) {
              if (value == 'Logout') {
                print("Edit Clicked");
                // TODO: Navigate to edit screen
                PrefrenceManager.clearPreferences();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[PopupMenuItem<String>(value: 'Logout', child: Text('Logout'))],
          ),
        ],
      ),
    );
  }
}
