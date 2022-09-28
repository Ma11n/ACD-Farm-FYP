import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CurrentUser {
  // CurrentUser({
  //   required this.id,
  //   required this.name,
  //   required this.email,
  //   required this.phone,
  //   required this.profilePic,
  //   required this.password,
  //   required this.role,
  //   required this.status,
  //   required this.employeeType,
  //   required this.timestamp,
  // });

  RxString id = ''.obs;
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString profilePic = ''.obs;
  RxString password = ''.obs;
  RxString role = ''.obs;
  RxBool status = true.obs;
  RxString employeeType = ''.obs;
  RxString address = "".obs;
  Rx<Timestamp> timestamp = Timestamp.now().obs;

  userFromDB(Map<String, dynamic> snapshot) {
    id.value = snapshot["id"] ?? '';
    name.value = snapshot["name"] ?? '';
    email.value = snapshot["email"] ?? '';
    phone.value = snapshot["phone"] ?? '';
    profilePic.value = snapshot["profilePic"] ?? '';
    password.value = snapshot["password"] ?? '';
    role.value = snapshot["role"] ?? '';
    status.value = snapshot["status"] ?? true;
    employeeType.value = snapshot["employeeType"] ?? '';
    address.value = snapshot["address"] ?? '';

    timestamp.value = snapshot["timestamp"] ?? Timestamp.now();
  }
}
