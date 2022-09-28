import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Animals {
  Animals(
      {required this.id,
      required this.age,
      required this.catergory,
      required this.gender,
      required this.pic,
      required this.puchasedCity,
      required this.purchasedPrice,
      required this.remarks,
      required this.sellPrice,
      required this.parentId,
      required this.srNo,
      required this.status,
      required this.timestamp,
      required this.disableReason,
      required this.adminId});
  String id = "";
  String srNo = "";
  String catergory = "";
  int purchasedPrice = 0;
  String age = "";
  String puchasedCity = "";
  String parentId = "";
  int sellPrice = 0;
  String disableReason = "";
  String gender = "";
  bool status = true;
  String remarks = "";
  String adminId = "";
  String pic = '';

  List<Children> children = <Children>[].obs;
  List<Journal> journalList = <Journal>[].obs;
  Timestamp timestamp = Timestamp.now();

  factory Animals.fromDB(Map<String, dynamic> snap) {
    return Animals(
      id: snap["id"] ?? '',
      age: snap["age"] ?? '',
      catergory: snap["category"] ?? "",
      gender: snap["gender"] ?? "",
      pic: snap["pic"] ?? "",
      puchasedCity: snap["puchasedCity"] ?? '',
      purchasedPrice: snap["purchasedPrice"] ?? 0,
      remarks: snap["remarks"] ?? "",
      sellPrice: snap["sellPrice"] ?? 0,
      srNo: snap["srNo"] ?? "",
      status: snap["status"] ?? "",
      timestamp: snap["timestamp"] ?? Timestamp.now(),
      disableReason: snap["disableReason"] ?? '',
      adminId: snap["adminId"] ?? '',
      parentId: snap["parentId"] ?? '',
    );
  }
}

class Children {
  String id = "";
  String srNo = "";
  String catergory = "";
  int purchasedPrice = 0;
  String age = "";
  String puchasedCity = "";
  int sellPrice = 0;
  String gender = "";
  bool status = true;
  String remarks = "";
  String pic = '';
  Timestamp timestamp = Timestamp.now();
}

class Journal {
  Journal({
    required this.adminId,
    required this.detail,
    required this.timestamp,
    required this.title,
    required this.date,
  });
  String adminId = "";
  String title = '';
  String date = '';
  String detail = "";
  Timestamp timestamp = Timestamp.now();

  factory Journal.fromDB(Map<String, dynamic> snap) => Journal(
        adminId: snap["adminId"] ?? '',
        detail: snap["detail"] ?? '',
        timestamp: snap["timestamp"] ?? Timestamp.now(),
        title: snap["title"] ?? '',
        date: snap["date"] ?? '',
      );
}
