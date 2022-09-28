import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Employee {
  RxList<EmployeeList> lst = <EmployeeList>[].obs;
}

class EmployeeList {
  EmployeeList({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.password,
    required this.role,
    required this.status,
    required this.employeeType,
    required this.timestamp,
  });
  String id = '';
  String name = '';
  String email = '';
  String phone = '';
  String profilePic = '';
  String password = '';
  String role = '';
  bool status = true;
  String employeeType = '';
  Timestamp timestamp = Timestamp.now();

  factory EmployeeList.fromDB(Map<String, dynamic> snap) {
    return EmployeeList(
      id: snap["id"] ?? '',
      name: snap["name"] ?? '',
      email: snap["email"] ?? '',
      phone: snap["phone"] ?? '',
      profilePic: snap["profilePic"] ?? '',
      password: snap['password'] ?? '',
      role: snap["role"] ?? '',
      status: snap["status"] ?? true,
      employeeType: snap["employeeType"] ?? '',
      timestamp: snap["timestamp"] ?? Timestamp.now(),
    );
  }
}
