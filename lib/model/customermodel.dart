import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Customer {
  RxList<CustomerList> lst = <CustomerList>[].obs;
}

class CustomerList {
  CustomerList({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.password,
    required this.role,
    required this.status,
    required this.address,
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
  String address = "";
  bool status = true;
  String employeeType = '';
  Timestamp timestamp = Timestamp.now();

  factory CustomerList.fromDB(Map<String, dynamic> snap) {
    return CustomerList(
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
      address: snap["address"] ?? "",
    );
  }
}
