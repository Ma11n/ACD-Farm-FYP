import 'package:dairyfarmapp/controller/customercontroller.dart';
import 'package:dairyfarmapp/controller/milkcontroller.dart';
import 'package:dairyfarmapp/controller/selectemployee.dart';
import 'package:dairyfarmapp/functions/functions.dart';
import 'package:dairyfarmapp/model/customermodel.dart';
import 'package:dairyfarmapp/screens/adduser/adduser.dart';
import 'package:dairyfarmapp/screens/customer/customermilk.dart';
import 'package:dairyfarmapp/screens/customer/customerprofile.dart';
import 'package:dairyfarmapp/screens/customer/specificannouncement.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomerScreen extends StatelessWidget {
  CustomerScreen({Key? key}) : super(key: key);

  final CustomerController _customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Customers"),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Enabled'),
              // Tab(text: 'CATS', icon: Icon(Icons.music_note)),
              Tab(
                text: 'Disabled',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(
                  () => const AddUser(
                      screenTitle: "Customer", userRole: "customer"),
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
                  _customerController.getCusomers();
                  
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: const TabBarView(
          children: [
            EnabledUsers(
              forEnable: true,
            ),
            EnabledUsers(
              forEnable: false,
            )
          ],
        ),
      ),
    );
  }
}

settingDialog(CustomerList userData) {
  return Get.defaultDialog(
    title: "Options",
    middleText: "Choose one from these",
    actions: [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
        ),
        onPressed: () {
          Get.to(() => CustomerProfile(user: userData));
        },
        child: const Text("Show Detail"),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
        ),
        onPressed: () {
          Get.to(() => SpecificAnnouncement(
                customer: userData,
              ));
        },
        child: const Text("Announcement"),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
        ),
        onPressed: () {
          Get.to(() => CustomerPurchasedMilk(
                customer: userData,
              ));
        },
        child: const Text("Milk Detail"),
      ),
    ],
  );
}

Widget customerCard(BuildContext context, CustomerList data,
    CustomerController customerController) {
  final MilkController milkController = Get.put(MilkController());

  final empController = Get.put(SelectedEmployee());
  var employee = getemployee();
  final formKey = GlobalKey<FormState>();

  TextEditingController quantity = TextEditingController();
  void sellMilk(context) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              // height: 400,
              child: Column(
                children: [
                  ListTile(
                      title: const Text(
                        'Choose Option',
                        style: TextStyle(color: Colors.white),
                      ),
                      tileColor: primaryColor,
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 100,
                      child: TxtField(
                        label: "Quatity in KG",
                        controller: quantity,
                        forPass: false,
                        keyboard: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Quantity can not be empty!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 400.h,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            "Select Employee",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ...List.generate(
                            employee.length,
                            (index) {
                              var emp = employee[index];

                              return Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Material(
                                  child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      tileColor: primaryColor,
                                      textColor: txtColor,
                                      title: Text(emp['name']),
                                      leading: Obx(
                                        () => Radio(
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    txtColor),
                                            value: index,
                                            groupValue:
                                                empController.group.value,
                                            onChanged: (val) {
                                              empController.selectEmp(
                                                  val, emp["id"]);
                                              // emplyeeId = emp["id"];
                                            }),
                                      )),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          primaryColor,
                        ),
                      ),
                      child: const Text("Sell"),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (double.parse(quantity.text) <
                              milkController.milk.remainingMilk.value) {
                            showLoader(context);

                            milkController.sellMilk(
                                data.id,
                                empController.id.value,
                                double.parse(quantity.text),
                                milkController.milk.price);
                            quantity.clear();
                            // Get.back();
                            Navigator.of(context).pop();
                          } else {
                            showBanner("Error!", "Invalid Milk Quantity");
                            stopLoader();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  return Container(
    margin: const EdgeInsets.only(left: 45),
    width: 1.sw,
    height: 150.h,
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
                          customerController.changeStatus(data.id, data.status);
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
                              )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                height: 50,
                // width: 80,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(txtColor)),
                  onPressed: () {
                    settingDialog(data);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.settings,
                        color: primaryColor,
                      ),
                      Text(
                        "Setting",
                        style: TextStyle(color: primaryColor, fontSize: 12.sp),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                height: 50,
                // width: 80,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(txtColor)),
                  onPressed: () {
                    sellMilk(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.sell,
                        color: primaryColor,
                      ),
                      Text(
                        "Sell Milk",
                        style: TextStyle(color: primaryColor, fontSize: 12.sp),
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

class EnabledUsers extends StatefulWidget {
  const EnabledUsers({super.key, required this.forEnable});

  final bool forEnable;

  @override
  State<EnabledUsers> createState() => _EnabledUsersState();
}

class _EnabledUsersState extends State<EnabledUsers> {
  final CustomerController controller = Get.put(CustomerController());

  final TextEditingController search = TextEditingController();

  RxList<CustomerList> enabledUsers = <CustomerList>[].obs;
  RxList<CustomerList> disabledUsers = <CustomerList>[].obs;
  RxList<CustomerList> enabledFilteredList = <CustomerList>[].obs;
  RxList<CustomerList> disabledFilteredList = <CustomerList>[].obs;

  @override
  void initState() {
    super.initState();
    // setState(() {
    enabledUsers = controller.enabledUser;
    disabledUsers = controller.disableUser;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: 1.sw,
          height: 100.h,
          child: SizedBox(
            width: 1.sw - 150,
            child: TxtField(
              onchange: (value) {
                if (widget.forEnable) {
                  // enabledUsers = <CustomerList>[].obs;
                  // filteredList = <CustomerList>[].obs;
                  enabledUsers.clear();
                  controller.gettingEnabledCustomer();
                  List<CustomerList> searchingLst = controller.enabledUser;
                  enabledFilteredList.clear();

                  for (CustomerList ele in searchingLst) {
                    if (ele.name.toLowerCase().contains(value!.toLowerCase())) {
                      enabledFilteredList.add(ele);
                    }
                  }
                  // setState(() {
                  enabledUsers = enabledFilteredList;
                  // });
                } else {
                  disabledUsers.clear();
                  disabledFilteredList.clear();
                  controller.gettingDisableCustomer();
                  List listForSearching = controller.disableUser;
                  for (CustomerList ele in listForSearching) {
                    if (ele.name.contains(value!)) {
                      disabledFilteredList.add(ele);
                    }
                  }
                  // setState(() {
                  disabledUsers = disabledFilteredList;
                  // });
                }
              },
              label: "Search",
              controller: search,
              forPass: false,
              keyboard: TextInputType.text,
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: (widget.forEnable == true)
                  ? enabledUsers.length
                  : disabledUsers.length,
              itemBuilder: (BuildContext context, int index) {
                var user = (widget.forEnable == true)
                    ? enabledUsers[index]
                    : disabledUsers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      customerCard(context, user, controller),
                      Positioned(
                        left: 0,
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
    );
  }
}
