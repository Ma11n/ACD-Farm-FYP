import 'package:dairyfarmapp/controller/adminexpensecontroller.dart';
import 'package:dairyfarmapp/controller/customerexpensecontroller.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddExpenses extends StatelessWidget {
  AddExpenses({Key? key, required this.forAdmin}) : super(key: key);
  final bool forAdmin;
  final TextEditingController expenseAmount = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final CustomerExpenseController _customerExpenseController =
      Get.put(CustomerExpenseController());
  final AdminExpenseController _adminExpenseController =
      Get.put(AdminExpenseController());
  final RxString selectedDates = ''.obs;
  final TextEditingController title = TextEditingController();
  final TextEditingController detail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Add Expenses"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 1.sw - 20,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor)),
                          onPressed: () {
                            Get.bottomSheet(
                              SfDateRangePicker(
                                maxDate: DateTime.now(),
                                showActionButtons: true,
                                onSubmit: (p0) {
                                  if (selectedDates.isNotEmpty) {
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
                                confirmText: "Done",
                                onCancel: () {
                                  Get.back();
                                },
                                backgroundColor: txtColor,
                                selectionColor: primaryColor,
                                todayHighlightColor: primaryColor,
                                onSelectionChanged: _onSelectionChanged,
                                selectionMode:
                                    DateRangePickerSelectionMode.single,
                              ),
                            );
                          },
                          child: const Text("Select Date"),
                        ),
                        Obx(() => Text(selectedDates.value)),
                      ],
                    ),
                  ),
                  TxtField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Title can not be empty";
                      }
                      return null;
                    },
                    label: "Title",
                    controller: title,
                    forPass: false,
                    keyboard: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TxtField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Quantity can not be empty";
                      }
                      return null;
                    },
                    label: "Amount",
                    controller: expenseAmount,
                    forPass: false,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: primaryColor,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: TextField(
                        controller: detail,
                        maxLines: 8, //or null
                        decoration: const InputDecoration.collapsed(
                          hintText: "Enter your text here",
                        )),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedDates.isNotEmpty) {
                            showLoader(context);
                            if (forAdmin == false) {
                              _customerExpenseController.addExpense(
                                  title.text,
                                  selectedDates.value,
                                  int.parse(expenseAmount.text),
                                  detail.text.trim());
                            } else {
                              _adminExpenseController.addExpense(
                                  title.text,
                                  int.parse(expenseAmount.text),
                                  detail.text.trim(),
                                  selectedDates.value);
                            }
                            expenseAmount.clear();
                            detail.clear();
                            title.clear();
                            selectedDates.value = '';
                          } else {
                            Get.snackbar(
                              "ERROR",
                              "Please select a date.",
                              backgroundColor: primaryColor,
                              icon: const Icon(
                                Icons.error,
                                color: txtColor,
                              ),
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              duration: const Duration(milliseconds: 1000),
                              colorText: txtColor,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(10),
                            );
                          }
                        }
                      },
                      child: const Text("ADD"),
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

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(args.value);
    selectedDates.value = formattedDate;
  }
}
