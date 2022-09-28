import 'package:dairyfarmapp/controller/usercontroller.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:dairyfarmapp/util/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CurrentUserController _controller = Get.put(CurrentUserController());

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _id = TextEditingController();

  final TextEditingController _phone = TextEditingController();
  bool editing = false;
  bool updateProfilebtn = false;
  var _uploadPicVisible = false;
  var _image;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (updateProfilebtn == false) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    editing = true;

                    updateProfilebtn = true;
                  });
                });
              }
            },
            icon: const Icon(Icons.update),
          )
        ],
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: 1.sh,
          width: 1.sw,
          child: Form(
            key: _formKey,
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
                                  style: theme.textTheme.subtitle1!.copyWith(
                                      color: theme.colorScheme.onPrimary),
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
                  child: (_controller.user.profilePic.value == '')
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
                              image: NetworkImage(
                                  _controller.user.profilePic.value),
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
                const SizedBox(
                  height: 50,
                ),
                Obx(
                  () => TxtField(
                    label: "id",
                    canEdit: false,
                    controller: _id..text = _controller.user.id.toString(),
                    forPass: false,
                    keyboard: TextInputType.name,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => TxtField(
                    onlyCharaters: true,
                    label: "Name",
                    canEdit: editing,
                    controller: _name..text = _controller.user.name.toString(),
                    forPass: false,
                    keyboard: TextInputType.name,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => TxtField(
                    label: "Email",
                    canEdit: false,
                    controller: _email
                      ..text = _controller.user.email.toString(),
                    forPass: false,
                    keyboard: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => TxtField(
                    label: "Phone",
                    canEdit: editing,
                    controller: _phone
                      ..text = _controller.user.phone.toString(),
                    forPass: false,
                    keyboard: TextInputType.phone,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => TxtField(
                    label: "Address",
                    canEdit: editing,
                    controller: _address
                      ..text = _controller.user.address.toString(),
                    forPass: false,
                    keyboard: TextInputType.streetAddress,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  visible: updateProfilebtn,
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showLoader(context);
                          _controller.updateProfile(
                              _name.text.trim(), _phone.text, _address.text,true,"");
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              editing = false;

                              updateProfilebtn = false;
                            });
                          });
                        }
                      },
                      child: const Text("Update Profile"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
      }),
    );
  }

//function for Selecting image
  Future getImage(ImageSource source) async {
    showLoader(context);
    final XFile? photo = await _picker.pickImage(source: source);

    setState(() {
      if (_uploadPicVisible == false) {
        _uploadPicVisible = true;
      }
      _image = photo;
    });
    stopLoader();
  }
}
