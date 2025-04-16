import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fmsisc_third_app/support/app_costants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../support/prefrence_manager.dart';
import '../login/login_model.dart';
import 'add_suggestion_screen.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

class AddSuggestioController extends GetxController {
  Rx<LoginModel>? loginModel = LoginModel().obs;

  RxBool isTermConditionChecked = false.obs;

  Rx<TextEditingController> titleTextController = TextEditingController().obs;
  Rx<TextEditingController> suggestionTextController = TextEditingController().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form key

  Rx<File> image = File("").obs;

  Future<void> pickImage() async {
    // final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    final pickedFile = await pickAndCompressImage();
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.back();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.back();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.back();
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // or ImageSource.gallery

    if (pickedFile == null) return null;

    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.absolute.path, "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg");

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 60, // Compression quality (0-100)
    );

    print("Original: ${File(pickedFile.path).lengthSync()} bytes");
    print("Compressed: ${File(result!.path).lengthSync()} bytes");

    return result;
  }

  Future<void> uploadData({
    required String title,
    required String riverID,
    required String districtId,
    required String block,
    required String village,
    required String riverSide,
    // required String sangathanID,
    // required String circleID,
    // required String divisionID,
    required String photoTaken,
  }) async {
    var dio = Dio();

    try {
      Get.dialog(Center(child: CircularProgressIndicator(color: appColor)), barrierDismissible: false);

      Position position = await _determinePosition();

      // Uint8List dataList = await drawTextOnImage(image.value.readAsBytesSync(), position);

      // Correct file upload format
      Map<String, dynamic> as = {
        'WorkImage': await dios.MultipartFile.fromFile(
          image.value.path,
          filename: 'Screenshot_20250323_203754.png', // Provide a valid filename
        ),
        'UserID': loginModel!.value.id,
        'Title': title,
        'DistrictID': districtId,
        'Block': block,
        "RiverName": riverID,
        'Village': village,
        // Add Accuracy
        'RiverSide': riverSide, // Add RiverSide
        // 'SangathanID': sangathanID,
        // 'CircleID': circleID,
        // 'DivisionID': divisionID,
        'Latitude': position.latitude,
        'Elevation': position.altitude, // Add Elevation
        'Accuracy': position.accuracy,
        'Longitude': position.longitude,
        'PhotoTaken': photoTaken,
        'DateTime': DateTime.now().toIso8601String(),
      };
      var formData = dios.FormData.fromMap(as);
      print("=====$as");
      var response = await dio.post(
        'https://pioneersparklellc.com/api/appphotoapi/paimgupload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data', // ✅ Set the correct header
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Get.back();
        showImageTextDialog(Get.overlayContext!);
        // ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(content: Text("Form submitted successfully!")));
        // Future.delayed(Duration(seconds: 1), () => Get.offAll(FormScreen()));
      }
    } on DioException catch (e) {
      print("Exception: ${e.response!}");
      Get.back();
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(content: Text("Error : ${e.response!.data?["message"]}")));
    } catch (e) {
      Get.back();
      print("Exception: $e");
    }
  }

  void showImageTextDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: mat.Image.file(image.value, height: 100, width: 100)),
                const SizedBox(height: 16),
                Text('Image has been upload successfully.', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    PrefrenceManager.clearPreferences();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    PrefrenceManager.getLoginData().then((value) {
      print(value!.toJson());
      loginModel!.value = value!;
    });
  }
}
