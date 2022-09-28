import 'dart:developer';
import 'dart:typed_data';

import 'package:dairyfarmapp/functions/getdate.dart';
import 'package:dairyfarmapp/model/customermodel.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class ReceptScreen extends StatelessWidget {
  ReceptScreen(
      {Key? key,
      required this.customer,
      required this.totalMilk,
      required this.totalPrice})
      : super(key: key);

  final CustomerList customer;
  final String totalMilk;
  final String totalPrice;

  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Screenshot(
                controller: controller,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 400.h,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      (customer.profilePic == '')
                          ? Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: primaryColor,
                                size: 40,
                              ),
                            )
                          : Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(customer.profilePic),
                                  fit: BoxFit.contain,
                                ),
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Bill Date", style: TextStyle(fontSize: 18.sp)),
                          Text(getCurrrentDate(),
                              style: TextStyle(fontSize: 18.sp)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Name", style: TextStyle(fontSize: 18.sp)),
                          Text(customer.name,
                              style: TextStyle(fontSize: 18.sp)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Milk", style: TextStyle(fontSize: 18.sp)),
                          Text("$totalMilk KG",
                              style: TextStyle(fontSize: 18.sp)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Bill", style: TextStyle(fontSize: 18.sp)),
                          Text("$totalPrice PKR",
                              style: TextStyle(fontSize: 18.sp)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor)),
                onPressed: () async {
                  final image = await controller.capture();
                  if (image == null) return;
                  var path = await saveImage(image);
                  log(path);
                },
                child: const Text("Save Recept"),
              )
            ],
          ),
        ),
      ),
    );
  }

  saveImage(Uint8List image) async {
    await [Permission.storage].request();
    final result = await ImageGallerySaver.saveImage(image,
        name: "${customer.name} $getCurrrentDate()");
    Get.snackbar("Success", "Recept Saved to ${result['filePath']}",
        backgroundColor: primaryColor,
        colorText: txtColor,
        snackPosition: SnackPosition.BOTTOM);
    return result["filePath"];
  }
}
