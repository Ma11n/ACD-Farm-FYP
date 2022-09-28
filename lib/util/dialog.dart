import 'package:dairyfarmapp/util/constents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

showMessage(
  String msg,
  String title,
  Color clr,
  void Function() action,
) {
  return Get.defaultDialog(
    title: title,
    titleStyle: TextStyle(color: clr),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            msg,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
          onPressed: action,
          child: const Text("OK"),
        )
      ],
    ),
  );
}

showBanner(String title, String message) {
  return Get.snackbar(
    title,
    message,
    backgroundColor: primaryColor,
    icon: const Icon(
      Icons.error,
      color: txtColor,
    ),
    animationDuration: const Duration(milliseconds: 600),
    duration: const Duration(milliseconds: 1500),
    colorText: txtColor,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(10),
  );
}
