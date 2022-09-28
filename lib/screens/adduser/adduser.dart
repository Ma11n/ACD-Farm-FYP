import 'package:dairyfarmapp/functions/functions.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key, required this.screenTitle, required this.userRole})
      : super(key: key);
  final String screenTitle;
  final String userRole;

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _userName = TextEditingController();

  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPhone = TextEditingController();

  final TextEditingController _userPass = TextEditingController();

  final TextEditingController _userConfirmPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  int _groupValue = -1;
  String employeeType = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Add ${widget.screenTitle}',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(
                    height: 10.h,
                  ),
                  TxtField(
                    keyboard: TextInputType.emailAddress,
                    label: "Email",
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
                  SizedBox(
                    height: 10.h,
                  ),
                  TxtField(
                    keyboard: TextInputType.phone,
                    label: "Phone",
                    controller: _userPhone,
                    forPass: false,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Phone cannot be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TxtField(
                    keyboard: TextInputType.visiblePassword,
                    label: "Password",
                    controller: _userPass,
                    forPass: true,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Password cannot be empty";
                      } else if (value.length < 8) {
                        return "Password must be 8 characters long";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TxtField(
                    keyboard: TextInputType.visiblePassword,
                    label: "Confirm Password",
                    controller: _userConfirmPass,
                    forPass: true,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Confirm Password can not be empty';
                      } else if (value != _userPass.text) {
                        return "Password does not match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Visibility(
                    visible: (widget.userRole == 'employee') ? true : false,
                    maintainSize: true,
                    maintainState: true,
                    maintainAnimation: true,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Select Type",
                            style: TextStyle(color: primaryColor, fontSize: 20),
                          ),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: _groupValue,
                              onChanged: (value) {
                                setState(() {
                                  employeeType = "delivery";
                                  _groupValue = value.hashCode;
                                });
                              },
                            ),
                            const Text("Delivery"),
                            const SizedBox(
                              width: 20,
                            ),
                            Radio(
                              value: 1,
                              groupValue: _groupValue,
                              onChanged: (value) {
                                setState(() {
                                  employeeType = "sell";
                                  _groupValue = value.hashCode;
                                });
                              },
                            ),
                            const Text("Sell"),
                            // const SizedBox(
                            //   width: 20,
                            // ),
                            // Radio(
                            //   value: 2,
                            //   groupValue: _groupValue,
                            //   onChanged: (value) {
                            //     setState(() => _groupValue = value.hashCode);
                            //   },
                            // ),
                            // const Text("delivery"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 50.h,
                    width: 200.w,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          primaryColor,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showLoader(context);

// String email, String pass, String userName, String role,
//     String employeeType, String phone
                          createUserByAdmin(
                            _userEmail.text.trim(),
                            _userPass.text,
                            _userName.text.trim(),
                            widget.userRole,
                            employeeType,
                            _userPhone.text,
                          );
                        }
                      },
                      child: const Text("Add User"),
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
}
