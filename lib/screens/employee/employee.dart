import 'package:dairyfarmapp/controller/employeecontroller.dart';
import 'package:dairyfarmapp/model/employeemodel.dart';
import 'package:dairyfarmapp/screens/adduser/adduser.dart';
import 'package:dairyfarmapp/screens/profile/user/employeeprofile.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final TextEditingController search = TextEditingController();

  final EmployeeController _employeeController = Get.put(EmployeeController());

  final _formKey = GlobalKey<FormState>();

  RxList<EmployeeList> employeeList = <EmployeeList>[].obs;

  @override
  void initState() {
    super.initState();

    employeeList = _employeeController.employee.lst;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Employees"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Get.to(
                () => const AddUser(
                    screenTitle: "Employee", userRole: "employee"),
              );
            },
            child: const Text(
              "Add",
              style: TextStyle(
                color: txtColor,
                fontSize: 18,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                showLoader(context);
                _employeeController.getEmployees();

                employeeList = _employeeController.employee.lst;
                search.clear();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: 1.sw,
            height: 100.h,
            child: SizedBox(
              width: 1.sw - 150,
              child: Form(
                key: _formKey,
                child: TxtField(
                  onchange: (value) {
                    var data = _employeeController.employee.lst;
                    RxList<EmployeeList> filteredList = <EmployeeList>[].obs;
                    for (var element in data) {
                      if (element.name
                          .toLowerCase()
                          .contains(value!.toLowerCase())) {
                        // print(element);
                        filteredList.add(element);
                      }
                    }
                    if (filteredList.isNotEmpty) {
                      employeeList.clear();

                      employeeList.addAll(filteredList);
                    }

                    // _employeeController.searchUserbyName(value!.trim());
                  },
                  label: "Search",
                  controller: search,
                  forPass: false,
                  keyboard: TextInputType.text,
                ),
              ),
            ),
          ),
          Expanded(
            // child: UsersList(query: query, userArr: userArr),
            child: Obx(
              () => ListView.builder(
                // itemCount: _employeeController.employee.lst.length,
                itemCount: employeeList.length,
                itemBuilder: (BuildContext context, int index) {
                  // var user = _employeeController.employee.lst[index];
                  EmployeeList user = employeeList[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      children: [
                        customerCard(context, user),
                        Positioned(
                          top: 20,
                          child: (user.profilePic == '')
                              ? Container(
                                  height: 80,
                                  width: 80,
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
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(user.profilePic),
                                      fit: BoxFit.contain,
                                    ),
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
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
    );
  }

  settingDialog(EmployeeList userData) {
    return Get.defaultDialog(
      title: "Options",
      middleText: "Choose one from these",
      actions: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
          onPressed: () {
            Get.to(() => EmployeeProfile(
                  user: userData,
                ));
          },
          child: const Text("Show Detail"),
        ),
      ],
    );
  }

  Widget customerCard(BuildContext context, EmployeeList data) {
    return Container(
      margin: const EdgeInsets.only(left: 45),
      width: 1.sw,
      height: 120.h,
      child: Card(
        color: primaryColor,
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 30.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          data.name,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        data.phone == ''
                            ? "Phone Number Not Added"
                            : "Phone: ${data.phone}",
                        style: const TextStyle(
                            color: txtColor, fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          _employeeController.changeStatus(
                              data.id, data.status);
                        },
                        child: data.status == true
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "Enabled",
                                  style: TextStyle(color: txtColor),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "Disabled",
                                  style: TextStyle(color: txtColor),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  // height: 50,
                  width: 80.w,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(txtColor)),
                    onPressed: () {
                      settingDialog(data);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.settings,
                          color: primaryColor,
                        ),
                        Text(
                          "Setting",
                          style: TextStyle(color: primaryColor),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
