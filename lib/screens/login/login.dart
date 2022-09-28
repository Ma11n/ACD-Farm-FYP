import 'package:dairyfarmapp/functions/functions.dart';
import 'package:dairyfarmapp/screens/signup/signup.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(-5, 5),
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 20,
                            )
                          ]),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: -20,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(5, -5),
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 20,
                            )
                          ]),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300.h,
                        child: Column(
                          children: [
                            // CircleAvatar(
                            //   backgroundColor: primaryColor,
                            //   foregroundColor: txtColor,
                            //   radius: 50,
                            //   child: ClipOval(
                            //     child: Text(
                            //       "D",
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 25.sp),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              height: 250.h,
                              width: 250.w,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/logo.png"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "ACD Farm",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 300.w,
                        child: Column(
                          children: [
                            // email textfield

                            TxtField(
                              keyboard: TextInputType.emailAddress,
                              controller: _userEmail,
                              label: 'Email',
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Email cannot be empty";
                                } else if (!value.contains("@") ||
                                    !value.contains(".com")) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                              forPass: false,
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            //Password Textfield
                            TxtField(
                              keyboard: TextInputType.visiblePassword,
                              controller: _userPass,
                              label: 'Password',
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Password can not be empty";
                                } else if (value.length < 6) {
                                  return "Password must be 6 characters long";
                                }
                                return null;
                              },
                              forPass: true,
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 300.w,
                              height: 50.h,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        primaryColor)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    showLoader(context);
                                    userSignIn(_userEmail, _userPass);
                                  }
                                },
                                child: const Text("Login"),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? "),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => SignUpScreen());
                                  },
                                  child: const Text(
                                    "Sign Up!",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
