import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/controller/announcementcontroller.dart';
import 'package:dairyfarmapp/controller/milkcontroller.dart';
import 'package:dairyfarmapp/functions/functions.dart';
import 'package:dairyfarmapp/screens/annuncement/viewannoucements.dart';
import 'package:dairyfarmapp/screens/login/login.dart';
import 'package:dairyfarmapp/screens/profile/adminprofile/adminprofile.dart';
import 'package:dairyfarmapp/screens/receipt/customerrecipt.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomerDashboard extends StatelessWidget {
  CustomerDashboard({
    Key? key,
  }) : super(key: key);

  final MilkController _milkController = Get.put(MilkController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    _milkController.getMilkForCustomer(_auth.currentUser!.uid);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (getTotalPrice() > 0) {
                Get.to(() => ReceptScreenCustomer(
                      totalMilk: getTotalMilk().toString(),
                      totalPrice: getTotalPrice().toString(),
                    ));
              } else {
                showBanner("Info", "No Milk Detial Found");
              }
            },
            icon: const Icon(Icons.print),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          centerTitle: true,
          title: const Text("Milk Detail"),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => const ProfileScreen());
                },
                icon: const Icon(Icons.person)),
            Obx(
              () => IconButton(
                onPressed: () {
                  Get.to(() => ViewAnnouncement());
                },
                icon: Badge(
                  badgeContent: Text(_controller.adminlst.length.toString()),
                  child: const Icon(Icons.message),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: "Logout!",
                      middleText: "Are your Sure you want to Logout?",
                      actions: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(primaryColor)),
                            onPressed: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              _auth.signOut().then((value) {
                                pref.remove("role");
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (route) => false);
                              });
                            },
                            child: const Text("Logout")),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(primaryColor)),
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("Cencal")),
                      ]);
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Column(
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
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      onPressed: () {
                        showLoader(context);
                        _milkController.getMilkForCustomer(
                            FirebaseAuth.instance.currentUser!.uid);
                      },
                      child: const Text("Show Today"),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      onPressed: () {
                        // Get.to(() => DatePicker());
                        Get.bottomSheet(
                          SfDateRangePicker(
                            showActionButtons: true,
                            onSubmit: (p0) {
                              if (selectedDates.isNotEmpty) {
                                showLoader(context);
                                _milkController.getCustomerMilkRange(
                                    selectedDates, _auth.currentUser!.uid);
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
                            selectionMode:
                                DateRangePickerSelectionMode.multiple,
                          ),
                        );
                      },
                      child: const Text("Select Date"),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Obx(
                    () => ListView.builder(
                      itemCount: _milkController.customerMilk.customers.length,
                      itemBuilder: (BuildContext context, int index) {
                        var adMilk =
                            _milkController.customerMilk.customers[index];
                        final Timestamp timestamp = adMilk.timestamp;
                        final DateTime dateTime = timestamp.toDate();
                        final dateString =
                            DateFormat('dd-MM-yyyy').format(dateTime);
                        final timeString =
                            DateFormat('hh-mm a').format(dateTime);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: txtColor,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(5, 5),
                                  color: primaryColor.withOpacity(0.4),
                                  blurRadius: 5,
                                )
                              ]),
                          child: Column(
                            children: [
                              Text(
                                dateString.toString(),
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Customer Name:"),
                                  FutureBuilder(
                                    future: getNameFromId(adMilk.customerId),
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Admin Name:"),
                                  FutureBuilder(
                                    future: getNameFromId(adMilk.adminId),
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Emplyee Name:"),
                                  FutureBuilder(
                                    future: getNameFromId(adMilk.emplyeeId),
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Milk Quantity"),
                                  Text("${adMilk.milkQuantity.toString()} KG"),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Time"),
                                  Text(timeString)
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: 1.sw,
                // height: 100.h,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Milk",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "${getTotalMilk().toString()} KG",
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Bill",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "${getTotalPrice().toString()} PKR",
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  double getTotalMilk() {
    double totolMilk = 0;
    for (var element in _milkController.customerMilk.customers) {
      totolMilk = totolMilk + element.milkQuantity;
    }

    return totolMilk;
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var element in _milkController.customerMilk.customers) {
      var sum = element.milkQuantity * element.price;
      totalPrice = totalPrice + sum;
    }
    return totalPrice;
  }
}
