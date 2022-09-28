import 'package:dairyfarmapp/controller/animalcontroller.dart';
import 'package:dairyfarmapp/model/animal.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';

class AddJournal extends StatelessWidget {
  AddJournal({Key? key, required this.animal}) : super(key: key);
  final Animals animal;
  final TextEditingController title = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AnimalController _controller = Get.put(AnimalController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Add Journal"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            width: 1.sw,
            height: 1.sh,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        primaryColor,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (detail.text == "") {
                          showBanner("Error!", "Add Detail!");
                        } else {
                          showLoader(context);
                          _controller.addJournal(
                            title.text.trim(),
                            detail.text,
                            animal.id,
                          );

                          title.clear();
                          detail.clear();
                          showBanner("Success!", "Journal Added");
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
    );
  }
}
