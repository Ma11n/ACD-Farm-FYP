import 'package:dairyfarmapp/controller/animalcontroller.dart';
import 'package:dairyfarmapp/model/animal.dart';
import 'package:dairyfarmapp/screens/animalchildren/children.dart';
import 'package:dairyfarmapp/screens/animals/addanimal.dart';
import 'package:dairyfarmapp/screens/animals/animaldetail.dart';
import 'package:dairyfarmapp/screens/animalsjournal/journal.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewAnimals extends StatefulWidget {
  const ViewAnimals({Key? key}) : super(key: key);

  @override
  State<ViewAnimals> createState() => _ViewAnimalsState();
}

class _ViewAnimalsState extends State<ViewAnimals> {
  final _formKey = GlobalKey<FormState>();

  final AnimalController _controller = Get.put(AnimalController());

  final TextEditingController search = TextEditingController();

  List<Animals> animalsList = <Animals>[].obs;
  List<Animals> listForSearching = <Animals>[].obs;

  @override
  void initState() {
    super.initState();

    animalsList = _controller.lst;
    listForSearching = _controller.lst;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                _controller.getAnimals();
                animalsList = _controller.lst;
              },
              icon: const Icon(
                Icons.refresh,
                color: txtColor,
              )),
          TextButton(
            onPressed: () {
              Get.to(() => const AddAnimal(
                    animal: null,
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
                  validator: (val) {
                    if (val == '' || val == null) {
                      return 'Search field cannot be empty';
                    }
                    return null;
                  },
                  label: "Search",
                  controller: search,
                  forPass: false,
                  onchange: (value) {
                    List<Animals> filteredList = <Animals>[].obs;

                    for (var element in animalsList) {
                      if (element.srNo.contains(value!)) {
                        // print(element.srNo);
                        filteredList.add(element);
                      }
                    }
                    if (filteredList.isNotEmpty) {
                      animalsList.clear();

                      animalsList.addAll(filteredList);
                    }
                  },
                  keyboard: TextInputType.text,
                ),
              ),
            ),
          ),
          Expanded(
            // child: UsersList(query: query, userArr: userArr),
            child: Obx(
              () => ListView.builder(
                itemCount: _controller.lst.length,
                itemBuilder: (BuildContext context, int index) {
                  var animal = _controller.lst[index];
                  [index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimalCard(
                          data: animal,
                          controller: _controller,
                        ),
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
}

class AnimalCard extends StatefulWidget {
  const AnimalCard({Key? key, required this.data, required this.controller})
      : super(key: key);
  final Animals data;
  final AnimalController controller;
  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  // final MilkController milkController = Get.put(MilkController());

  // final empController = Get.put(SelectedEmployee());
  // var employee = getemployee();
  RxString dropdownvalue = 'Death'.obs;

  // List of items in our dropdown menu
  var items = [
    'Death',
    'Salled',
  ];
  TextEditingController salledPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 45),
      width: 1.sw,
      height: 200.h,
      child: Card(
        color: primaryColor,
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 45.0),
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
                          "SR No: ${widget.data.srNo}",
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        "Gender: ${widget.data.gender}",
                        style: const TextStyle(
                            color: txtColor, fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.data.status == true) {
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
                                          widget.controller.changeStatus(
                                              widget.data.id,
                                              widget.data.status,
                                              dropdownvalue.value,
                                              salledPrice.text);
                                          Get.back();
                                        },
                                        child: const Text("Change Status"))
                                  ],
                                ));
                          }
                        },
                        child: widget.data.status == true
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
                      Text(
                        "Reason: ${widget.data.disableReason}",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
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
                          "Category: ${widget.data.catergory}",
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
                        "Age: ${widget.data.age}",
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
                                        animal: widget.data,
                                        forChildren: false,
                                      ));
                                },
                                child: const Text("Show Detail"),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primaryColor),
                                ),
                                onPressed: () {
                                  Get.to(() => AnimalJournal(
                                        animal: widget.data,
                                      ));
                                },
                                child: const Text("Show Journal"),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primaryColor),
                                ),
                                onPressed: () {
                                  Get.to(
                                    () => AnimalChildren(
                                      parentAnimal: widget.data,
                                    ),
                                  );
                                },
                                child: const Text("Show Children"),
                              )
                            ],
                          );
                        },
                        child: const Text(
                          "Show More",
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ),
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
