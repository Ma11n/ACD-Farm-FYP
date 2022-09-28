import 'package:dairyfarmapp/screens/login/login.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200.h,
            width: 1.sw,
            decoration: BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 5),
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 5,
                )
              ],
              borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(100.h),
                bottomRight: Radius.circular(80.h),

                // topRight: Radius.circular(100.h),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      color: txtColor, borderRadius: BorderRadius.circular(50)),
                  child: const Center(
                    child: Text(
                      "A",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Admin Nmae",
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          ListTile(
            tileColor: primaryColor.withOpacity(0.05),
            leading: const Icon(
              Icons.home,
              color: primaryColor,
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          ListTile(
            tileColor: primaryColor.withOpacity(0.05),
            leading: const Icon(
              Icons.person,
              color: primaryColor,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              onTap: () {
                _auth.signOut().then((value) {
                  Get.off(LoginScreen());
                });
              },
              tileColor: primaryColor.withOpacity(0.05),
              leading: const Icon(
                Icons.logout_rounded,
                color: primaryColor,
              ),
              title: const Text(
                "Log out",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
