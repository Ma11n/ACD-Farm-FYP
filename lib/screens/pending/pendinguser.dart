import 'package:dairyfarmapp/screens/login/login.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatusPendingScreen extends StatelessWidget {
  UserStatusPendingScreen({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 1.sw,
              child: Lottie.asset("assets/animation/pending.json",
                  // "https://assets2.lottiefiles.com/packages/lf20_nk5g0wbx.json",
                  fit: BoxFit.cover),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Your account status is disabled. Please wait for confirmation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              width: 300,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                ),
                child: const Text("Log out"),
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();

                  _auth.signOut().then((value) {
                    pref.remove("role");
                    Get.off(LoginScreen());
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
