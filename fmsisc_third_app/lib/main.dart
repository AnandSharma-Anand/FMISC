import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fmsisc_third_app/screens/add_suggestion/add_suggestion_screen.dart';
import 'package:fmsisc_third_app/screens/homescreen.dart';
import 'package:fmsisc_third_app/screens/login/login_model.dart';
import 'package:fmsisc_third_app/screens/login/login_screen.dart';
import 'package:fmsisc_third_app/support/app_costants.dart';
import 'package:fmsisc_third_app/support/prefrence_manager.dart';
import 'package:get/get.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState,
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PrefrenceManager.getLoginData().then((value) {
        LoginModel? loginModel = value;
        if (loginModel != null) {
          Future.delayed(const Duration(seconds: 3), () => Get.offAll(HomeScreen()));
        } else {
          Future.delayed(const Duration(seconds: 3), () => Get.offAll(LoginScreen()));
        }
      });
    });
  }

  Future<void> cacheImage() async {
    final cacheManager = DefaultCacheManager();
    await cacheManager.putFile('assets/master_background.png', (await DefaultAssetBundle.of(context).load('assets/master_background.png')) as Uint8List);
    await cacheManager.putFile('assets/up_govt.png', (await DefaultAssetBundle.of(context).load('assets/up_govt.png')) as Uint8List);
    await cacheManager.putFile('assets/logo.png', (await DefaultAssetBundle.of(context).load('assets/logo.png')) as Uint8List);
    await cacheManager.putFile('assets/map.png', (await DefaultAssetBundle.of(context).load('assets/map.png')) as Uint8List);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: appColor),
      child: Scaffold(
        body: FutureBuilder(
          future: cacheImage(),
          builder:
              (context, snapshot) => Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(gradient: linearGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Image.asset('assets/up_govt.png', width: Get.width / 3),

                      Image.asset('assets/logo.png', width: Get.width / 2.0),
                      const SizedBox(height: 5),
                      Text('सिंचनेन समृद्धि भवति', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold, fontSize: 22)),
                      const SizedBox(height: 20),
                      FittedBox(child: Text('Flood Management Information System Centre', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red.shade600))),
                      const SizedBox(height: 20),
                      const Text('Irrigation & Water Resources Department', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Text('Uttar Pradesh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      Expanded(child: Padding(padding: const EdgeInsets.all(18.0), child: Image.asset('assets/map.png', width: Get.width / 1, height: Get.width / 3))),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
