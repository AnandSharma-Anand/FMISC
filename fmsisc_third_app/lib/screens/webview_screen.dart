import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fmsisc_third_app/support/app_costants.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewScreen extends StatefulWidget {
  String url;
  String pageName;

  @override
  _WebViewScreenState createState() => _WebViewScreenState();

  WebViewScreen(this.url, this.pageName);
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            commonAppbar(),
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      // ✅ Enable JavaScript
                      domStorageEnabled: true,
                      // ✅ Allow local storage (needed for some map APIs)
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
                      geolocationEnabled: true,
                      transparentBackground: true,
                      supportMultipleWindows: true,
                      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                      // For loading content over HTTP/HTTPS
                      useHybridComposition: true, // Required for proper rendering on Android
                    ),
                    onCreateWindow: (controller, createWindowRequest) async {
                      // Instead of creating a new window, load the URL in the current webview
                      print(createWindowRequest.request.url.toString().split(".").last);
                      if(createWindowRequest.request.url.toString().split(".").last=="pdf"){
                        requestStoragePermission();
                      }
                   /*  setState(() {
                       controller.loadUrl(urlRequest: createWindowRequest.request);
                     });*/
                      return true; // Indicates that you have handled the new window request
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      // Optionally, you can intercept URL loads here if needed
                      return NavigationActionPolicy.ALLOW;
                    },
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print("Console Message: ${consoleMessage.message}");
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        isLoading = true;
                      }); // Show loader
                    },
                    onLoadStop: (controller, url) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator()) // Loader
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> requestManageStoragePermission() async {
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      print("Manage Storage Permission Granted");
    } else {
      print("Permission Denied");
    }
  }

  Widget commonAppbar() {
    return Container(
      color: appColor,
      width: Get.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(widget.pageName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
          Spacer(),
        ],
      ),
    );
  }
}
