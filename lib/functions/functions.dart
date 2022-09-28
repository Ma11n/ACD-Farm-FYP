import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/screens/customerdashboard/customerdashboard.dart';
import 'package:dairyfarmapp/screens/dashboard/admin/admindashboard.dart';
import 'package:dairyfarmapp/screens/pending/pendinguser.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

final FirebaseFirestore db = FirebaseFirestore.instance;

//creating user with out signing in
createUserByAdmin(String email, String pass, String userName, String role,
    String employeeType, String phone) async {
  FirebaseApp app = await Firebase.initializeApp(
      name: 'Secondary', options: Firebase.app().options);

  try {
    await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(
      email: email,
      password: pass,
    )
        .then((value) {
      // if (value.credential != null) {
      log("user Added");

      String userId = value.user!.uid;
      Map<String, dynamic> user = {
        "id": userId,
        "name": userName,
        "email": email,
        "role": role,
        'phone': phone,
        "passowrd": pass,
        "employeeType": employeeType,
        "status": true,
        "profilePic": "",
        "timestamp": Timestamp.now()
      };

      db.collection("users").doc(userId).set(user).then((value) {
        stopLoader();
        showMessage('$role Added', "Added!", Colors.green, () {
          Get.off(() => AdminDashboard());
        });
      });
    }
            // }
            );
  } on FirebaseAuthException catch (err) {
    log(err.toString());
    stopLoader();
    showMessage(err.message.toString(), "Error!", Colors.red, () {
      Get.back();
    });
  }

  await app.delete();
}

// sign in user
userSignIn(TextEditingController email, TextEditingController pass) async {
  try {
    await auth
        .signInWithEmailAndPassword(
            email: email.text.toString().trim(), password: pass.text.toString())
        .then((value) async {
      String userId = value.user!.uid;

      var userData =
          await db.collection("users").doc(userId).get().then((value) {
        return value.data();
      });
      var userRole = userData!["role"];
      var userStatis = userData['status'];
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove("role");
      if (userStatis == true) {
        if (userRole == 'admin') {
          Get.off(() => AdminDashboard(), popGesture: false);
          pref.setString("role", "admin");
        } else if (userRole == 'customer') {
          Get.off(() => CustomerDashboard(), popGesture: false);
          pref.setString("role", "customer");
        } else {
          Get.off(() => UserStatusPendingScreen(), popGesture: false);

          pref.setString("role", "customer");
        }
      } else {
        Get.off(() => UserStatusPendingScreen(), popGesture: false);
        pref.setString("role", "customer");
      }

      stopLoader();
    });

    // Get.off(const AdminDashboard());

  } on FirebaseAuthException catch (e) {
    stopLoader();
    // showBanner("error", e.toString());

    showMessage(e.message.toString(), "Error!", Colors.red, () {
      Get.back();
    });
    log(e.toString());
  }
}

//Customer sign up
signUpCustomer(String name, String email, String phone, String pass) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await auth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      if (value.user != null) {
        String id = value.user!.uid;
        Map<String, dynamic> user = {
          "id": value.user!.uid,
          "name": name,
          "email": email,
          'phone': phone,
          "role": 'customer',
          "passowrd": pass,
          "status": false,
          "profilePic": "",
          "timestamp": Timestamp.now()
        };
        db.collection('users').doc(id).set(user).then((value) {
          stopLoader();
          pref.setString("role", "customer");

          Get.off(() => UserStatusPendingScreen());
        });
      }
    });
  } on FirebaseAuthException catch (e) {
    log(e.toString());
    stopLoader();
    // showBanner("error", e.toString());
    showMessage(e.message.toString(), "Error!", Colors.red, () {
      Get.back();
    });
  }
}

getemployee() {
  var data = [];
  db
      .collection("users")
      .where("employeeType", isEqualTo: "delivery")
      .where("status", isEqualTo: true)
      .get()
      .then((value) {
    data.clear();
    if (value.docs.isNotEmpty) {
      data.addAll(value.docs);
    }
  });

  return data;
}

//geting user name from his id
getNameFromId(String id) async {
  return await db.collection("users").doc(id).get();
}

// getting days of week by selected date
List getDaysOfWeek(DateTime date) {
  var weekDayslist = [];

  var currentWeekDay = date.weekday;

//week starts from monday
  var firstDayOfWeek = date.subtract(Duration(days: currentWeekDay - 1));

  weekDayslist.clear();
  for (var i = 0; i < 7; i++) {
    final nextDate = DateTime(
        firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day + i);
    weekDayslist.add(nextDate);
  }

  // var dayname = DateFormat('EEEE').format(tomorrow);
  // weekDayslist.reversed;
  return weekDayslist;
}

getDaysOfMonth(DateTime date) {
  var monthDayslist = [];

  var beginningSelectedMonth = (date.month < 12)
      ? DateTime(date.year, date.month, 1)
      : DateTime(date.year, 1, 1);
  var numberofdaysinMonth = (date.month < 12)
      ? DateTime(date.year, date.month + 1, 1)
      : DateTime(date.year, 1, 1);
  var lastDay = numberofdaysinMonth.subtract(const Duration(days: 1)).day;

  monthDayslist.clear();
  for (var i = 0; i < lastDay; i++) {
    final nextDate = DateTime(beginningSelectedMonth.year,
        beginningSelectedMonth.month, beginningSelectedMonth.day + i);
    monthDayslist.add(nextDate);
  }

  return monthDayslist;
}
