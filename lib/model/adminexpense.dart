import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class AdminExpense {
  RxString id = "".obs;
  List<AdminExpList> expenseList = <AdminExpList>[].obs;
}

class AdminExpList {
  AdminExpList({
    required this.title,
    required this.adminId,
    required this.date,
    required this.amount,
    required this.detail,
    required this.timestamp,
  });
  String title = '';
  String adminId = '';
  String date = '';
  int amount = 0;
  String detail = '';
  Timestamp timestamp = Timestamp.now();

  factory AdminExpList.fromDB(Map<String, dynamic> snap) => AdminExpList(
        title: snap["title"] ?? "",
        adminId: snap["adminId"] ?? "",
        amount: snap["amount"] ?? 0,
        detail: snap["detail"] ?? '',
        timestamp: snap["timestamp"] ?? Timestamp.now(),
        date: snap["date"] ?? '',
      );
}
