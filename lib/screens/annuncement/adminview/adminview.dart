import 'package:dairyfarmapp/controller/announcementcontroller.dart';
import 'package:dairyfarmapp/functions/functions.dart';
import 'package:dairyfarmapp/functions/getdate.dart';
import 'package:dairyfarmapp/model/announcement.dart';
import 'package:dairyfarmapp/screens/annuncement/anouncement.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ViewAnnouncementFormCustomer extends StatelessWidget {
  ViewAnnouncementFormCustomer({Key? key}) : super(key: key);

  final AnnouncementController _controller = Get.put(AnnouncementController());

  final selectedDates = [];

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    selectedDates.clear();
    // for (var ele in args.value) {
    //   print(ele);
    // }
    selectedDates.addAll(args.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Annoucement"),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          TextButton(
              onPressed: () {
                Get.to(() => AddAnnouncement(
                      forAdmin: true,
                    ));
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: 1.sh,
        width: 1.sw,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: 1.sw,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      _controller.getAnnouncementByCustomer(getCurrrentDate());
                    },
                    child: const Text("Show Today"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      // Get.to(() => DatePicker());
                      Get.bottomSheet(
                        SfDateRangePicker(
                          showActionButtons: true,
                          onSubmit: (p0) {
                            if (selectedDates.isNotEmpty) {
                              showLoader(context);

                              _controller.getAnnouncementByCustomerDateRande(
                                  selectedDates);
                              Get.back();
                            } else {
                              Get.defaultDialog(
                                  content: const Text(
                                      "Please select at least one date"),
                                  actions: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryColor)),
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text("OK"))
                                  ]);
                            }
                          },
                          headerStyle: const DateRangePickerHeaderStyle(
                              backgroundColor: primaryColor,
                              textStyle: TextStyle(color: txtColor)),
                          confirmText: "Filter",
                          backgroundColor: txtColor,
                          selectionColor: primaryColor,
                          todayHighlightColor: primaryColor,
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode: DateRangePickerSelectionMode.multiple,
                        ),
                      );
                    },
                    child: const Text("Select Date"),
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: _controller.customerlst.length,
                  itemBuilder: (BuildContext context, int index) {
                    Announcement journal = _controller.customerlst[index];
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 5),
                              color: primaryColor.withOpacity(0.5),
                              blurRadius: 5)
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            journal.title,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Customer Name",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              FutureBuilder(
                                future: getNameFromId(journal.userId),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Text(
                                        snapshot.data["name"].toString());
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.none) {
                                    return const Text("No data");
                                  }
                                  return const CircularProgressIndicator(
                                    color: primaryColor,
                                    strokeWidth: 2,
                                  );
                                },
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       "Customer Phone",
                          //       style: TextStyle(
                          //         color: primaryColor,
                          //         fontSize: 15.sp,
                          //         fontWeight: FontWeight.w700,
                          //       ),
                          //     ),
                          //     FutureBuilder(
                          //       future: getphoneFromID(journal.userId),
                          //       builder: (BuildContext context,
                          //           AsyncSnapshot snapshot) {
                          //         if (snapshot.connectionState ==
                          //             ConnectionState.done) {
                          //           return Text(snapshot.data["phone"]);
                          //         } else if (snapshot.connectionState ==
                          //             ConnectionState.none) {
                          //           return const Text("No data");
                          //         }
                          //         return const CircularProgressIndicator(
                          //           color: primaryColor,
                          //           strokeWidth: 2,
                          //         );
                          //       },
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "date:",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                journal.date == ""
                                    ? "Not Defined"
                                    : journal.date,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Detail",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            height: 2,
                            width: 250.w,
                            color: primaryColor,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              journal.detail,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getNameFromID(String id) {
    return db.collection("users").doc(id).get().then((value) {
      var userData = value.data();

      return userData!["name"];
    });
  }

  getphoneFromID(String id) {
    return db.collection("users").doc(id).get().then((value) {
      var userData = value.data();

      return userData!["name"] ?? '';
    });
  }
}
