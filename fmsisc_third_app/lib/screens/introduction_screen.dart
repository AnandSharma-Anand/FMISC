import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmsisc_third_app/screens/login/login_screen.dart';
import 'package:get/get.dart';

import '../support/app_costants.dart';

class IntroScreen extends StatelessWidget {
  final Color primaryBlue = Color(0xFF005DAA); // Approximated from the image

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: appColor),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Blue Header
              Container(
                color: appColor,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.white, child: Image.asset("assets/logo.png")),
                    SizedBox(width: 8),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('FMISC', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white))]),
                  ],
                ),
              ),
          
              // Body Scroll View
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                childAspectRatio: 1,
                children: [
                  CounterCard(
                    iconUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8LLgPM73uYyeYM7qvzQHtIpVW75ZLYWVq4Q&s",
                    title: 'Shri Yogi Adhityanath',
                    designation: "Hon'ble Chief Minister\nUttar Pradesh",
                  ),
          
                  CounterCard(
                    iconUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtFaYv4T5CLlp66LmMyQ1OMqyzUCMfXbTs6g&s",
                    title: 'Shri Swatantra Dev Singh',
                    designation: "Hon'ble Cabinet Minister Jai Shakti, Uttar Pradesh",
                  ),
                  CounterCard(
                    iconUrl: "https://starsunfolded.com/wp-content/uploads/2022/07/Dinesh-Khatik.jpg",
                    title: 'Shri Dinesh Khateek',
                    designation: "Hon'ble Minister of State Jai Shakti, Uttar Pradesh",
                    isFlip: true,
                  ),
                  CounterCard(
                    iconUrl: "https://i0.wp.com/timesoftaj.com/wp-content/uploads/2024/07/IMG-20240718-WA0289.jpg?fit=905%2C926&ssl=1",
                    title: 'Shri Ramkesh Nishad',
                    designation: "Hon'ble Minister of State Jai Shakti, Uttar Pradesh",
                    isFlip: true,
                  ),
                ],
              ),
          Spacer(),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  'FMISC UP की वेबसाइट पर विभिन्न सेवाएं उपलब्ध हैं, जैसे:दैनिक हाइड्रोमेट स्टेटस: राज्य में जल स्तर और वर्षा की दैनिक जानकारी। बाढ़ बुलेटिन: बाढ़ की स्थिति और पूर्वानुमान से संबंधित नियमित अपडेट। इंटरएक्टिव मैप्स: बाढ़ प्रभावित क्षेत्रों का दृश्य प्रतिनिधित्व। Alexa स्किल: "FMISC UP Flood Bulletin" नामक Alexa स्किल के माध्यम से बाढ़ से संबंधित जानकारी प्राप्त करना।',
                style: TextStyle(fontSize: 18),),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.offAll(LoginScreen());
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: appColor),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18)), SizedBox(width: 10), Icon(Icons.arrow_circle_right, color: Colors.white)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterCard extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String designation;
  bool? isFlip = false;

  CounterCard({super.key, required this.iconUrl, required this.title, required this.designation, this.isFlip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      // height: 160,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(0), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(30)),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: const Offset(2, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY((isFlip ?? false) ? 3.1416 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Get.width),
              child: CachedNetworkImage(imageUrl: iconUrl, fit: BoxFit.cover, height: 100, width: 100, alignment: Alignment.topCenter),
              // child: Image.network(iconUrl, fit: BoxFit.cover, height: 100, width: 100, alignment: Alignment.topCenter),
            ),
          ),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: Text(designation, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
