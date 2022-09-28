import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/controller/customerexpensecontroller.dart';
import 'package:dairyfarmapp/screens/customerexpenses/addexpenses.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ViewExpenses extends StatelessWidget {
  final selectedDates = [];
  ViewExpenses({Key? key}) : super(key: key);
  final CustomerExpenseController _expenseController =
      Get.put(CustomerExpenseController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Expenses"),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Get.to(() => AddExpenses(
                      forAdmin: true,
                    ));
              },
              child: const Text("ADD"))
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
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      _expenseController.getExpenseData();
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
                              //function for expense
                              _expenseController
                                  .getExpenseFromDateRange(selectedDates);
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
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Obx(
                  () => ListView.builder(
                    itemCount: _expenseController.expense.expensesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var expense =
                          _expenseController.expense.expensesList[index];
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
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Amount"),
                                Text(expense.amount.toString())
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
    int totolMilk = 0;
    for (var element in _expenseController.expense.expensesList) {
      totolMilk = totolMilk + element.amount;
    }

    return totolMilk;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    selectedDates.clear();

    selectedDates.addAll(args.value);
  }
}
