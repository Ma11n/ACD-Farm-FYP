import 'package:dairyfarmapp/controller/animalcontroller.dart';
import 'package:dairyfarmapp/model/animal.dart';
import 'package:dairyfarmapp/screens/animalsjournal/addjournal.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AnimalJournal extends StatelessWidget {
  AnimalJournal({Key? key, required this.animal}) : super(key: key);
  final AnimalController _controller = Get.put(AnimalController());
  final Animals animal;
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
    _controller.viewjournal(animal.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal"),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                _controller.viewjournal(animal.id);
              },
              icon: const Icon(
                Icons.refresh,
                color: txtColor,
              )),
          TextButton(
            onPressed: () {
              Get.to(() => AddJournal(
                    animal: animal,
                  ));
            },
            child: const Text(
              "ADD",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: 1.sh,
        width: 1.sw,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      _controller.viewjournal(animal.id);
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
                              _controller.viewJournalByDate(
                                  animal.id, selectedDates);
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
              child: Obx(
                () => ListView.builder(
                  itemCount: _controller.animals.journalList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Journal journal = _controller.animals.journalList[index];
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 5),
                              color: primaryColor.withOpacity(0.5),
                              blurRadius: 5)
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            journal.title,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "date:",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                journal.date == ""
                                    ? "Not Defined"
                                    : journal.date,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Detail",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            height: 2,
                            width: 250.w,
                            color: primaryColor,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              journal.detail,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
