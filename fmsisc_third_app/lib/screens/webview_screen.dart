import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fmsisc_third_app/support/app_costants.dart';
import 'package:get/get.dart';

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
                      javaScriptEnabled: true, // ✅ Enable JavaScript
                      domStorageEnabled: true, // ✅ Allow local storage (needed for some map APIs)
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
                      geolocationEnabled: true,
                      transparentBackground: true,
                      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW, // For loading content over HTTP/HTTPS
                      useHybridComposition: true, // Required for proper rendering on Android

                    ),
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
