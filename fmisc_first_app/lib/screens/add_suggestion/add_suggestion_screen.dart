import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

import '../../constanDatas.dart';
import '../../support/app_costants.dart';

class SuggestionForm extends StatefulWidget {
  const SuggestionForm({super.key});

  @override
  State<SuggestionForm> createState() => _SuggestionFormState();
}

class _SuggestionFormState extends State<SuggestionForm> {
  String latitudeLongitude = "";
  bool isOTPVerified = false;

  Color appColor = Colors.blue.shade900;
  final _formKey = GlobalKey<FormState>();
  final _suggestionformKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _suggestionController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: appColor),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppbar(),
              const SizedBox(height: 10),

              Visibility(
                visible: !isOTPVerified,
                replacement: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                          children: [TextSpan(text: "Suggestion Box"), TextSpan(text: "*", style: TextStyle(color: Colors.red))],
                        ),
                      ),
                    ),
                    Form(
                      key: _suggestionformKey,
                      child: Column(
                        children: [
                          getTextField(txtController: _subjectController, icon: Icons.subject, hint: "Subject"),

                          getTextField(txtController: _suggestionController, hint: "Write your suggestion here....", showLabel: false),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              _pickImageFromCamera();
                            },
                            child: Container(
                              height: 70,
                              width: 100,
                              decoration: BoxDecoration(color: appColor, border: Border.all(width: 1)),
                              margin: const EdgeInsets.all(15),
                              child: const Icon(Icons.camera_alt_outlined, size: 35, color: Colors.white),
                            ),
                          ),
                        ),
                        _imageFile != null
                            ? Image.file(_imageFile!, width: 115, height: 115, fit: BoxFit.contain)
                            : Text(
                              "Upload Image".capitalize.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                            ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Enter your details", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)),
                    ),
                    const SizedBox(height: 2),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          getTextField(txtController: _nameController, icon: Icons.person, hint: "Name"),
                          getTextField(txtController: _emailController, icon: Icons.email, hint: "Email address"),
                          getTextField(txtController: _phoneController, icon: Icons.phone_android_rounded, hint: "Mobile Number", isMobile: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (!isOTPVerified) {
                    if (_formKey.currentState!.validate()) {
                      showCircularBottomSheet(context);
                    }
                  } else {
                    if (_suggestionformKey.currentState!.validate()) {
                      print(_imageFile);
                      print(_imageFile.runtimeType);
                      print((_imageFile == null));
                      // if (_imageFilegeFile == null) {
                      //   showToast(message: "Kindly upload image.");
                      // } else {
                        submitSuggestion();
                      // }
                    }
                    // Get.back();
                  }
                  // showToast(message: "Under development");
                },
                child: Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: appColor, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    ((!isOTPVerified) ? "Next" : "Submit").toString().capitalize.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                ).marginOnly(bottom: 5),
              ),
              if (!isOTPVerified)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                      children: [TextSpan(text: "Note"), TextSpan(text: "*", style: TextStyle(color: Colors.red)), TextSpan(text: "Your details are safe and secure with us!")],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  File? _imageFile;

  Future<void> _pickImageFromCamera() async {
    ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget getTextField({TextEditingController? txtController, IconData? icon, String? hint, bool showLabel = true, bool isMobile = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: txtController,
        minLines: showLabel ? null : 5,
        maxLines: showLabel ? null : 500,
        inputFormatters: isMobile ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] : [],
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
          labelText: showLabel ? hint : null,
          hintText: showLabel ? null : hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.grey[100],

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${((hint!.replaceAll("Write", "")).replaceAll("here....", "").replaceAll("your", "")).trim()} cannot be empty!'.capitalizeFirst;
          }
          return null;
        },
      ),
    );
  }

  final TextEditingController _pinController = TextEditingController();
  bool _isError = false;
  double _shakeOffset = 0.0;

  void _triggerShake() {
    setState(() => _isError = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isError = false;
      });
    });
    setState(() {
      _pinController.text = "";
    });
  }

  void showCircularBottomSheet(BuildContext context) {
    setState(() {
      _pinController.text = "";
    });
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Circular top corners
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          // height: (Get.height/2.5)+(MediaQuery.of(context).viewInsets.bottom+((MediaQuery.of(context).viewInsets.bottom>0)?200:0)), // Custom height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Column(
                children: [
                  Text("Verify your mobile number".capitalize.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    "We are send a OTP to validate your\nmobile number. Hang on!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: _isError ? 10 : 0),
                duration: const Duration(seconds: 2),
                curve: Curves.elasticInOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: Pinput(
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyDecorationWith(border: Border.all(color: Colors.blue)),
                      errorTextStyle: const TextStyle(color: Colors.red),
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) {
                        if (pin != "1234") {
                          _triggerShake();
                          showToast(message: "Incorrect OTP!");
                        }
                      },
                    ),
                  );
                },
              ),
              Column(
                children: [
                  const SizedBox(height: 30),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey),
                      children: [TextSpan(text: "A SMS has been sent to "), TextSpan(text: "7533759304", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (_pinController.text.toString().trim().isEmpty) {
                        _triggerShake();
                        showToast(message: "Kindly enter the otp!");
                      } else if (_pinController.text.toString() != "1234") {
                        _triggerShake();
                        showToast(message: "Incorrect OTP!");
                      } else {
                        setState(() {
                          isOTPVerified = true;
                          Get.back();
                        });
                      }
                    },
                    child: Container(
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: appColor, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Verify".toString().capitalize.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                    ).marginOnly(bottom: 15),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
  );

  showToast({String? message}) {
    Get.snackbar("Message", message!, backgroundColor: Colors.white);
  }

  Future<void> submitSuggestion() async {
    Get.dialog(Center(child: CircularProgressIndicator(color: appColor)), barrierDismissible: false);
    var request = http.MultipartRequest('POST', Uri.parse('https://pioneersparklellc.com/api/appsuggapi/sappimageupload'));

    request.fields['UserName'] = _nameController.text;
    request.fields['MobileNo'] = _phoneController.text;
    request.fields['Email'] = _emailController.text;
    request.fields['SSubject'] = _subjectController.text;
    request.fields['Suggestion'] = _suggestionController.text;

    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'WorkImage', // Adjust parameter name if needed
          _imageFile!.path,
        ),
      );
    }

    var response = await request.send();
    Get.back();
    print(response.statusCode);
    if (response.statusCode == 200) {
      Get.back();
      showToast(message: "Suggestion submitted successfully!");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to submit form")));
    }
  }
}
