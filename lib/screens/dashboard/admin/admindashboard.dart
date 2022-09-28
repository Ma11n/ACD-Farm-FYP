import 'package:dairyfarmapp/controller/milkcontroller.dart';
import 'package:dairyfarmapp/screens/adduser/adduser.dart';
import 'package:dairyfarmapp/screens/adminexpenses/viewexpenseformadmin.dart';
import 'package:dairyfarmapp/screens/animals/viewanimals.dart';
import 'package:dairyfarmapp/screens/annuncement/adminview/adminview.dart';
import 'package:dairyfarmapp/screens/customer/customers.dart';
import 'package:dairyfarmapp/screens/employee/employee.dart';

import 'package:dairyfarmapp/screens/login/login.dart';
import 'package:dairyfarmapp/screens/profile/adminprofile/adminprofile.dart';
import 'package:dairyfarmapp/screens/sellmilk/milkdetail.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:dairyfarmapp/util/constents.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({Key? key}) : super(key: key);
  final TextEditingController milkQuantity = TextEditingController();
  final TextEditingController milkSource = TextEditingController();
  final TextEditingController milkPrice = TextEditingController();

  final MilkController _milkController = Get.put(MilkController());
  final _formKey = GlobalKey<FormState>();

  final List<Widget> dahboardButtons = [
    DashButton(
      title: 'Add Admin',
      icon: const Icon(
        Icons.admin_panel_settings,
        size: 40,
      ),
      onclicked: () {
        // showMessage("Test ", "Error!");
        Get.to(
          () => const AddUser(screenTitle: "Admin", userRole: "admin"),
        );
      },
    ),
    DashButton(
      title: 'Employee',
      icon: const Icon(
        Icons.person,
        size: 40,
      ),
      onclicked: () {
        Get.to(
          () => const EmployeeScreen(),
        );
      },
    ),
    DashButton(
      title: 'Customer',
      icon: const Icon(
        Icons.supervised_user_circle,
        size: 40,
      ),
      onclicked: () {
        Get.to(
          () => CustomerScreen(),
        );
      },
    ),
    DashButton(
      title: 'Milk',
      icon: const ImageIcon(
        AssetImage("assets/icons/milk.png"),
        size: 40,
      ),
      onclicked: () {
        Get.to(() => const MilkDetailScreen());
      },
    ),
    DashButton(
      title: 'Animals',
      icon: const ImageIcon(
        AssetImage("assets/icons/animal.png"),
        size: 40,
      ),
      onclicked: () {
        Get.to(() => const ViewAnimals());
      },
    ),
    DashButton(
      title: 'Expenses',
      icon: const ImageIcon(
        AssetImage("assets/icons/expenses.png"),
        size: 40,
      ),
      onclicked: () {
        Get.to(() => ViewAdminExpenses());
      },
    ),
    DashButton(
      title: 'Profile',
      icon: const ImageIcon(
        AssetImage("assets/icons/profile.png"),
        size: 40,
      ),
      onclicked: () {
        Get.to(
          () => const ProfileScreen(),
        );
      },
    ),
    DashButton(
      title: 'Announcement',
      icon: const Icon(
        Icons.message,
        size: 40,
      ),
      onclicked: () {
        Get.to(() => ViewAnnouncementFormCustomer());
      },
    ),
    DashButton(
        title: "Logout",
        icon: const Icon(Icons.logout),
        onclicked: () {
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
                      FirebaseAuth.instance.signOut().then((value) {
                        pref.remove("role");

                        Navigator.pushAndRemoveUntil(
                            Get.context!,
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
        })
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text("ACD Farm"),
            centerTitle: true,
          ),
          // drawer: Menu(),
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 20,
                    ),
                    margin: EdgeInsets.only(top: 20.h),
                    // height: 220.h,
                    width: 1.sw - 40,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 5),
                          blurRadius: 5,
                          color: primaryColor.withOpacity(0.3),
                        ),
                        BoxShadow(
                          offset: const Offset(-5, 0),
                          blurRadius: 5,
                          color: primaryColor.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Milk",
                                  style: TextStyle(
                                    color: txtColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Remaining",
                                  style: TextStyle(
                                    color: txtColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Price",
                                  style: TextStyle(
                                    color: txtColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // const Spacer(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    "${_milkController.milk.totalMilk.toStringAsFixed(2).toString()} KG",
                                    style: TextStyle(
                                      color: txtColor,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(
                                  () => Text(
                                    "${_milkController.milk.remainingMilk.toStringAsFixed(2).toString()} KG",
                                    style: TextStyle(
                                      color: txtColor,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(
                                  () => _milkController.milk.price.value > 0
                                      ? Text(
                                          "${_milkController.milk.price} PKR",
                                          // "1200 PKR",

                                          style: TextStyle(
                                            color: txtColor,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      : SizedBox(
                                          height: 30,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      txtColor),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColor),
                                            ),
                                            onPressed: () {
                                              addPrice(context);
                                            },
                                            child: const Text("Add Price"),
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(txtColor),
                              foregroundColor:
                                  MaterialStateProperty.all(primaryColor),
                            ),
                            onPressed: () {
                              addMilkDailog(context);

                              // addMilk(100, "cows");
                            },
                            child: const Text("Add Milk"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: AnimationLimiter(
                        child: GridView.count(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          children: List.generate(
                            dahboardButtons.length,
                            (int index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                columnCount: dahboardButtons.length,
                                child: ScaleAnimation(
                                  // scale: 1.5,
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FadeInAnimation(
                                      child: dahboardButtons[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addPrice(BuildContext context) {
    return Get.defaultDialog(
        title: "Add Milk",
        titleStyle: const TextStyle(color: primaryColor),
        content: Form(
          key: _formKey,
          child: TxtField(
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "price can not be empty";
              }
              return null;
            },
            label: "Price",
            controller: milkPrice,
            forPass: false,
            keyboard: TextInputType.number,
          ),
        ),
        actions: [
          SizedBox(
            width: 100,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  primaryColor,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  showLoader(context);
                  _milkController.addPrice(int.parse(milkPrice.text));
                  milkPrice.clear();
                  Get.back();
                }
              },
              child: const Text("Add"),
            ),
          )
        ]);
  }

  addMilkDailog(BuildContext context) {
    return Get.defaultDialog(
        title: "Add Milk",
        titleStyle: const TextStyle(color: primaryColor),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TxtField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Quatity can not be empty";
                  }
                  return null;
                },
                label: "Quantity",
                controller: milkQuantity,
                forPass: false,
                keyboard: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              TxtField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Source can not be empty";
                  }
                  return null;
                },
                label: "Source",
                controller: milkSource,
                forPass: false,
                keyboard: TextInputType.text,
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: 100,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  primaryColor,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showLoader(context);

                  _milkController.addMilk(
                      double.parse(milkQuantity.text), milkSource.text);

                  milkQuantity.clear();
                  milkSource.clear();
                  Get.back();
                }
              },
              child: const Text("Add"),
            ),
          )
        ]);
  }
}

class DashButton extends StatelessWidget {
  const DashButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onclicked,
  }) : super(key: key);

  final String title;
  final Widget icon;
  final Function onclicked;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(5),
        backgroundColor: MaterialStateProperty.all(txtColor),
        shadowColor: MaterialStateProperty.all(primaryColor),
        overlayColor: MaterialStateProperty.all(primaryColor),
        // surfaceTintColor: MaterialStateProperty.all(txtColor),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return txtColor; //<-- SEE HERE

          }
          return primaryColor;
        }),
      ),
      onPressed: () {
        onclicked();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sm),
          )
        ],
      ),
    );
  }
}
