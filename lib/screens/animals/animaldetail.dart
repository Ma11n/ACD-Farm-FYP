import 'dart:developer';
import 'dart:io';

import 'package:dairyfarmapp/util/dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dairyfarmapp/controller/animalcontroller.dart';
import 'package:dairyfarmapp/model/animal.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';

class AnimalDetail extends StatefulWidget {
  const AnimalDetail({
    Key? key,
    required this.animal,
    required this.forChildren,
  }) : super(key: key);

  final Animals? animal;

  final bool forChildren;
  @override
  State<AnimalDetail> createState() => _AnimalDetailState();
}

class _AnimalDetailState extends State<AnimalDetail> {
  final _formKey = GlobalKey<FormState>();

  final AnimalController _controller = Get.put(AnimalController());

  final TextEditingController _srNumber = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _purchased = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  int _groupValue = -1;
  String gender = '';
  bool updateProfilebtn = false;
  final _uploadPicVisible = false;
  var _image;
  String pinUrl = "";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.animal!.gender == "male") {
      setState(() {
        _groupValue = 0;
      });
    } else {
      setState(() {
        _groupValue = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Builder(builder: (context) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: 1.1.sh,
              width: 1.sw,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (() {
                        showBottomSheet(
                          context: context,
                          builder: (context) {
                            final theme = Theme.of(context);
                            // Using Wrap makes the bottom sheet height the height of the content.
                            // Otherwise, the height will be half the height of the screen.
                            return Wrap(
                              children: [
                                ListTile(
                                    title: Text(
                                      'Choose Option',
                                      style: theme.textTheme.subtitle1!
                                          .copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary),
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
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Choose From Camera'),
                                  onTap: () {
                                    getImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image_search),
                                  title: const Text('Choose From Gallery'),
                                  onTap: () {
                                    getImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                      child: (widget.animal?.pic == "")
                          ? Container(
                              height: 150,
                              width: 150,
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
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(widget.animal!.pic),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 5),
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                    )
                                  ]),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TxtField(
                      canEdit: false,
                      keyboard: TextInputType.name,
                      label: "Sr Number",
                      controller: _srNumber..text = widget.animal!.srNo,
                      forPass: false,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Sr number cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TxtField(
                      keyboard: TextInputType.name,
                      label: "Catergory",
                      controller: _category..text = widget.animal!.catergory,
                      forPass: false,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "category cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: !widget.forChildren,
                      child: TxtField(
                        keyboard: TextInputType.number,
                        label: "Purchased Price",
                        controller: _purchased
                          ..text = widget.animal!.purchasedPrice.toString(),
                        forPass: false,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Price cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: !widget.forChildren,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),
                    TxtField(
                      keyboard: TextInputType.number,
                      label: "Age",
                      controller: _age..text = widget.animal!.age,
                      forPass: false,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Age cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      maintainAnimation: true,
                      maintainSize: false,
                      maintainState: true,
                      visible: widget.animal == null ? true : false,
                      child: TxtField(
                        keyboard: TextInputType.name,
                        label: "Purchased City",
                        controller: _city..text = widget.animal!.puchasedCity,
                        forPass: false,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "city cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Gender",
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
                                  gender = "male";
                                  _groupValue = value.hashCode;
                                });
                              },
                            ),
                            const Text("Male"),
                            const SizedBox(
                              width: 20,
                            ),
                            Radio(
                              value: 1,
                              groupValue: _groupValue,
                              onChanged: (value) {
                                setState(() {
                                  gender = "female";
                                  _groupValue = value.hashCode;
                                });
                              },
                            ),
                            const Text("Female"),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TxtField(
                      keyboard: TextInputType.text,
                      label: "Remarks",
                      controller: _remarks..text = widget.animal!.remarks,
                      forPass: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor)),
                          child: const Text("Update"),
                          onPressed: () {
                            // if (_formKey.currentState!.validate()) {
                            if (gender != '') {
                              showLoader(context);
                              showBanner("Info", "Select Gender");
                            } else {
                              if (widget.forChildren) {
                                showLoader(context);

                                _controller.updateChildren(
                                  _srNumber.text,
                                  _category.text,
                                  int.parse(_purchased.text),
                                  _age.text,
                                  _city.text,
                                  gender,
                                  widget.animal!.parentId,
                                  _remarks.text,
                                  pinUrl,
                                  widget.animal?.id,
                                );
                              } else {
                                showLoader(context);

                                _controller.updateAnimal(
                                  _srNumber.text,
                                  _category.text,
                                  int.parse(_purchased.text),
                                  _age.text,
                                  _city.text,
                                  gender,
                                  _remarks.text,
                                  pinUrl,
                                  widget.animal?.id,
                                );
                              }
                            }
                          }
                          // },
                          ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void uploadImage(photo) async {
    showLoader(context);

    if (photo != null) {
      Reference reference = storage.ref().child("animal/${photo.name}/");
      UploadTask uploadTask = reference.putFile(File(photo.path));

      uploadTask.then((data) async {
        var url = await data.ref.getDownloadURL();

        setState(() {
          pinUrl = url;
          widget.animal!.pic = url;
        });

        stopLoader();
      });
    } else {
      stopLoader();
    }
  }

  Future getImage(ImageSource source) async {
    try {
      showLoader(context);
      final XFile? photo =
          await _picker.pickImage(source: source, imageQuality: 85);

      // setState(() {
      //   if (_uploadPicVisible == false) {
      //     _uploadPicVisible = true;
      //   }
      //   _image = photo;
      // });
      stopLoader();

      uploadImage(photo);
    } catch (e) {
      log(e.toString());
      stopLoader();
    }
  }
}
