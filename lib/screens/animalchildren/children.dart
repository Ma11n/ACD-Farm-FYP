import 'package:dairyfarmapp/screens/animals/animaldetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:dairyfarmapp/controller/animalcontroller.dart';
import 'package:dairyfarmapp/model/animal.dart';
import 'package:dairyfarmapp/screens/animals/addanimal.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/textfield.dart';

class AnimalChildren extends StatefulWidget {
  const AnimalChildren({
    Key? key,
    required this.parentAnimal,
  }) : super(key: key);

  final Animals parentAnimal;

  @override
  State<AnimalChildren> createState() => _AnimalChildrenState();
}

class _AnimalChildrenState extends State<AnimalChildren> {
  final AnimalController _controller = Get.put(AnimalController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController search = TextEditingController();

  RxList<Animals> childList = <Animals>[].obs;

  @override
  void initState() {
    super.initState();
    childList = _controller.children;
  }

  @override
  Widget build(BuildContext context) {
    _controller.viewChildren(widget.parentAnimal.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Children"),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                _controller.viewChildren(widget.parentAnimal.id);
              },
              icon: const Icon(
                Icons.refresh,
                color: txtColor,
              )),
          TextButton(
            onPressed: () {
              Get.to(() => AddAnimal(
                    animal: widget.parentAnimal,
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
                    var data = _controller.children;
                    RxList<Animals> filteredList = <Animals>[].obs;
                    for (var element in data) {
                      if (element.srNo.contains(value!)) {
                        filteredList.add(element);
                      }
                    }
                    if (filteredList.isNotEmpty) {
                      childList.clear();

                      childList.addAll(filteredList);
                    }
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
                itemCount: childList.length,
                itemBuilder: (BuildContext context, int index) {
                  var animal = childList[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        customerCard(context, animal, widget.parentAnimal.id),
                        Positioned(
                          left: 0,
                          child: (animal.pic == '')
                              ? Container(
                                  height: 80.h,
                                  width: 80.w,
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
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(animal.pic),
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

  Widget customerCard(BuildContext context, Animals data, String animalId) {
    // final MilkController milkController = Get.put(MilkController());

    // final empController = Get.put(SelectedEmployee());

    final AnimalController controller = Get.put(AnimalController());
    // var employee = getemployee();
    RxString dropdownvalue = 'Death'.obs;

    // List of items in our dropdown menu
    var items = [
      'Death',
      'Salled',
    ];
    TextEditingController salledPrice = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(left: 45),
      width: 1.sw,
      height: 200.h,
      child: Card(
        color: primaryColor,
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 30.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "SR No: ${data.srNo}",
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        "Gender: ${data.gender}",
                        style: const TextStyle(
                            color: txtColor, fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          if (data.status == true) {
                            Get.defaultDialog(
                                title: "Reason",
                                middleText:
                                    "Define the reason to disble animal",
                                content: Column(
                                  children: [
                                    Obx(
                                      () => DropdownButton(
                                        // Initial Value
                                        value: dropdownvalue.value,

                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: items.map((items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (newValue) {
                                          dropdownvalue.value =
                                              newValue.toString();
                                        },
                                      ),
                                    ),
                                    Obx(
                                      () => (dropdownvalue.value == "Salled")
                                          ? TxtField(
                                              label: "Salled Price",
                                              controller: salledPrice,
                                              forPass: false,
                                              keyboard: TextInputType.number)
                                          : TxtField(
                                              label: "Reason",
                                              controller: salledPrice,
                                              forPass: false,
                                              keyboard: TextInputType.text),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryColor)),
                                        onPressed: () {
                                          controller.changeAnimalStatus(
                                              data.srNo,
                                              data.status,
                                              dropdownvalue.value,
                                              salledPrice.text,
                                              animalId);
                                          Get.back();
                                        },
                                        child: const Text("Change Status"))
                                  ],
                                ));
                          }
                          // _controller.changeStatus(data.id, data.status);
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
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Category: ${data.catergory}",
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Age: ${data.age}",
                        style: const TextStyle(
                            color: txtColor, fontWeight: FontWeight.w600),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                            txtColor,
                          )),
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Setting",
                              middleText: "",
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(primaryColor),
                                  ),
                                  onPressed: () {
                                    Get.to(() => AnimalDetail(
                                          animal: data,
                                          forChildren: true,
                                        ));
                                  },
                                  child: const Text("Show Detail"),
                                ),
                                // ElevatedButton(
                                //   style: ButtonStyle(
                                //     backgroundColor:
                                //         MaterialStateProperty.all(primaryColor),
                                //   ),
                                //   onPressed: () {
                                //     Get.to(() => AnimalJournal(
                                //           animal: data,
                                //         ));
                                //   },
                                //   child: const Text("Show Journal"),
                                // ),
                                // ElevatedButton(
                                //   style: ButtonStyle(
                                //     backgroundColor:
                                //         MaterialStateProperty.all(primaryColor),
                                //   ),
                                //   onPressed: () {},
                                //   child: const Text("Show Children"),
                                // )
                              ],
                            );
                          },
                          child: const Text("Show More",
                              style: TextStyle(
                                color: primaryColor,
                              )))
                    ],
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
