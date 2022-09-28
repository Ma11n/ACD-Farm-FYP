// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/controller/adminexpensecontroller.dart';
import 'package:dairyfarmapp/functions/functions.dart';
import 'package:dairyfarmapp/screens/customerexpenses/addexpenses.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ViewAdminExpenses extends StatelessWidget {
  ViewAdminExpenses({Key? key}) : super(key: key);

  final AdminExpenseController _adminExpenseController =
      Get.put(AdminExpenseController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController searchField = TextEditingController();
  var selectedDates = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Expenses"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _adminExpenseController.getExpense();
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
          TextButton(
              onPressed: () {
                Get.to(() => AddExpenses(
                      forAdmin: true,
                    ));
              },
              child: const Text(
                "ADD",
                style: TextStyle(color: txtColor),
              ))
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
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      filteringExpenses(context, "day");
                    },
                    child: const Text("Filter Day"),
                  ),
                  //weekly filter button
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      // Get.to(() => DatePicker());
                      filteringExpenses(context, "week");
                    },
                    child: const Text("Fliter Weekly"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      // Get.to(() => DatePicker());
                      filteringExpenses(context, "month");
                    },
                    child: const Text("Fliter Monthly"),
                  ),
                ],
              ),
            ),
            Container(
              height: 70.h,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TxtField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Search field cannot be empty";
                          }
                          return null;
                        },
                        label: "Search By Title",
                        controller: searchField,
                        forPass: false,
                        keyboard: TextInputType.text,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showLoader(context);
                          _adminExpenseController
                              .searchByTitle(searchField.text.trim());
                          searchField.clear();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      child: const Text("Search"))
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Obx(
                  () => ListView.builder(
                    itemCount:
                        _adminExpenseController.expense.expenseList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var expense =
                          _adminExpenseController.expense.expenseList[index];
                      final Timestamp timestamp = expense.timestamp;
                      final DateTime dateTime = timestamp.toDate();
                      // final dateString =
                      //     DateFormat('dd-MM-yyyy').format(dateTime);
                      final timeString = DateFormat('hh-mm a').format(dateTime);

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
                              expense.date,
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Title"),
                                Text(
                                  expense.title,
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Amount"),
                                Text("${expense.amount.toString()} PKR")
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Time Added"),
                                Text(timeString),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Detail"),
                                Text(expense.detail),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: 1.sw,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Expense",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${getTotalExpense().toString()} PKR",
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  int getTotalExpense() {
    int totalExpense = 0;
    for (var element in _adminExpenseController.expense.expenseList) {
      totalExpense = totalExpense + element.amount;
    }
    return totalExpense;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    selectedDates.clear();
    selectedDates.add(args.value);
  }

  filteringExpenses(BuildContext context, String filterFor) {
    return Get.bottomSheet(
      SfDateRangePicker(
        showActionButtons: true,
        onSubmit: (p0) {
          if (selectedDates.isNotEmpty) {
            showLoader(context);
            //function for expense

            if (filterFor == "day") {
              _adminExpenseController.getExpenseDateRange(selectedDates);
            } else if (filterFor == "month") {
              var days = getDaysOfMonth(selectedDates[0]);
              _adminExpenseController.getExpenseDateRange(days);
            } else if (filterFor == "week") {
              var days = getDaysOfWeek(selectedDates[0]);
              _adminExpenseController.getExpenseDateRange(days);
            }

            Get.back();
          } else {
            Get.defaultDialog(
                content: const Text("Please select at least one date"),
                actions: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
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
        selectionMode: DateRangePickerSelectionMode.single,
      ),
    );
  }
}
