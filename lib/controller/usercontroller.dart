import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/model/user.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CurrentUserController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CurrentUser user = CurrentUser();

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  getCurrentUser() {
    String id = _auth.currentUser!.uid;

    db.collection("users").doc(id).get().then((value) {
      var data = value.data();

      user.userFromDB(data!);
    });
  }

  updateProfile(String name, String phone, String address, bool forAdmin,String userid) {
    String id =(forAdmin == true)? _auth.currentUser!.uid:userid;

    Map<String, dynamic> updateUser = {
      "name": name,
      "phone": phone,
      "address": address,
    };

    db.collection("users").doc(id).update(updateUser).then((value) {
      getCurrentUser();
      stopLoader();
      showBanner("Success!", "Profile updated");
    });
  }
}
