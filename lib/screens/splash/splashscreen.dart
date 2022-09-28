import 'package:after_layout/after_layout.dart';
import 'package:dairyfarmapp/screens/customerdashboard/customerdashboard.dart';
import 'package:dairyfarmapp/screens/dashboard/admin/admindashboard.dart';
import 'package:dairyfarmapp/screens/introslider/introslider.dart';
import 'package:dairyfarmapp/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  final FirebaseAuth _currentUser = FirebaseAuth.instance;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      if (_currentUser.currentUser != null) {
        var role = prefs.get("role");
        if (role == "customer") {
          Get.off(() => CustomerDashboard());
        } else if (role == "admin") {
          Get.off(() => AdminDashboard());
        }
      } else {
        Get.off(() => LoginScreen());
      }
    } else {
      Get.off(() => const IntroScreen());
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 250.h,
              width: 250.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                ),
              ),
            ),
            const CircularProgressIndicator(
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
