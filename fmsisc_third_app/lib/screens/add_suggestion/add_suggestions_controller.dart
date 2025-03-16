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
import '../../support/prefrence_manager.dart';
import '../login/login_model.dart';

class AddSuggestioController extends GetxController {
  Rx<LoginModel>? loginModel = LoginModel().obs;

  RxBool isTermConditionChecked = false.obs;

  Rx<TextEditingController> titleTextController = TextEditingController().obs;
  Rx<TextEditingController> suggestionTextController = TextEditingController().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form key

  Rx<File> image = File("").obs;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
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

  /*Future<void> _addTextToImage() async {
    // Decode image
    img.Image imageObj = img.decodeImage(image.value.readAsBytesSync())!;

    img.Color color=Color();
    img.drawString(
      imageObj,
      "Hello, Flutter!",
      font: img.arial48, // Use built-in Arial font
      x: 50, // X position
      y: 50, // Y position
      color:
    );

    // Convert image back to Uint8List
    Uint8List modifiedImageBytes = Uint8List.fromList(img.encodeJpg(imageObj));

    // Show in Dialog
    Get.dialog(
      mat.Dialog(
        child: mat.Container(
          padding: mat.EdgeInsets.all(10),
          child: mat.Column(
            mainAxisSize: mat.MainAxisSize.min,
            children: [
              mat.Image.memory(modifiedImageBytes),
              mat.SizedBox(height: 10),
              mat.Text("Modified Image", style: mat.TextStyle(fontSize: 18, fontWeight: mat.FontWeight.bold)),
              mat.TextButton(onPressed: () => Get.back(), child: mat.Text("Close")),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
*/

  Future<Uint8List> drawTextOnImage(Uint8List imageBytes, Position position) async {
    ui.Image originalImage = await decodeImageFromList(imageBytes);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw original image
    canvas.drawImage(originalImage, Offset.zero, Paint());

    // Prepare text
    final textPainter = TextPainter(
      text: TextSpan(text: "Location coordinate : ${position.latitude} ${position.longitude}", style: TextStyle(color: Colors.red, fontSize: 30)),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Flip the text vertically
    canvas.save(); // Save current canvas state
    canvas.translate(50, 50 + textPainter.height); // Move origin
    canvas.scale(1, -1); // Flip vertically

    // Draw text
    textPainter.paint(canvas, Offset.zero);

    canvas.restore(); // Restore original canvas state

    // Convert to Uint8List
    final picture = recorder.endRecording();
    final img = await picture.toImage(originalImage.width, originalImage.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    /*   await Get.dialog(
      Dialog(child: Padding(padding: EdgeInsets.all(10), child: Column(mainAxisSize: MainAxisSize.min, children: [mat.Image.memory(byteData!.buffer.asUint8List())]))),
      barrierDismissible: false,
    );*/
    return byteData!.buffer.asUint8List();
  }

  void uploadImage() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        showLongToast("No internet connection. Please check your network.");
        return;
      }
      Get.dialog(Center(child: CircularProgressIndicator(color: appColor)), barrierDismissible: false);

      Position position = await _determinePosition();

      Uint8List dataList = await drawTextOnImage(image.value.readAsBytesSync(), position);

      var headers = {'Content-Type': 'application/json'};
      List<String> listString = (image.value.path.split('/').last).toString().split(".");
      String fileName = "${DateTime.now()}${listString.first}";
      Map<String, dynamic> map = {
        // if (image.value.path.isNotEmpty) 'WorkImage': await dios.MultipartFile.fromFile(image.value.path, filename: image.value.path.split('/').last),
        if (image.value.path.isNotEmpty) 'WorkImage': await dios.MultipartFile.fromBytes(dataList, filename: '$fileName${listString.last}'),
        'UserID': loginModel!.value.id,
        'Title': titleTextController.value.text,
        'WorkDesc': suggestionTextController.value.text,
        'Latitude': position.latitude,
        'Longitude': position.longitude,
      };

      var data = dios.FormData.fromMap(map);
      print(map);
      var dio = Dio();
      var response = await dio.request('https://pioneersparklellc.com/api/WorkImageAPI', options: Options(method: 'POST', headers: headers), data: data);
      print(response.data);
      if (response.statusCode == 200) {
        Get.back();
        titleTextController.value.clear();
        suggestionTextController.value.clear();
        image.value = File("");
        isTermConditionChecked.value = false;
        showLongToast("Form submitted successfully!");
      } else {
        Get.back();
        print(response.statusMessage);
      }
    } on DioException catch (e) {
      Get.back();
      showLongToast("${e.response!.data?["message"]}");
      print("Server error: ${e.response!.data?["message"]}");
    } catch (e, str) {
      Get.back();
      print(e);
      print(str);
      showLongToast("Unexpected error: $e");
    }
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
