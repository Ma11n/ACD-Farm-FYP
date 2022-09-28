import 'package:dairyfarmapp/functions/functions.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPhone = TextEditingController();
  final TextEditingController _userPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top: 40,
                  child: Text(
                    "Sign UP",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 0,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: primaryColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300.w,
                      child: Column(
                        children: [
                          TxtField(
                            onlyCharaters: true,
                            keyboard: TextInputType.name,
                            label: "Name",
                            controller: _userName,
                            forPass: false,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Name cannot be empty";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            keyboard: TextInputType.emailAddress,
                            label: "email",
                            controller: _userEmail,
                            forPass: false,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Email cannot be empty";
                              } else if (!value.contains("@") ||
                                  !value.contains(".com")) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            keyboard: TextInputType.phone,
                            label: "phone",
                            controller: _userPhone,
                            forPass: false,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Phone cannot be empty";
                              } else if (value.length != 11) {
                                return "Please enter a valid phone number!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            keyboard: TextInputType.visiblePassword,
                            label: "password",
                            controller: _userPass,
                            forPass: true,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Password can not be empty";
                              } else if (value.length < 6) {
                                return "Password must be 6 characters long";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            keyboard: TextInputType.visiblePassword,
                            label: "Confirm Password",
                            controller: _confirmPass,
                            forPass: true,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Password can not be empty";
                              } else if (value.length < 6) {
                                return "Password must be 6 characters long";
                              } else if (value != _userPass.text) {
                                return "Password does not match";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 300.w,
                            height: 50.h,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  primaryColor,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  showLoader(context);
                                  signUpCustomer(
                                      _userName.text,
                                      _userEmail.text,
                                      _userPhone.text,
                                      _userPass.text);
                                }
                              },
                              child: const Text("Sign up"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
