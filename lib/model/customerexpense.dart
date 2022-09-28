// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class CustomerExpense {
  RxString id = ''.obs;
  List<ExpDetail> expensesList = <ExpDetail>[].obs;
}

class ExpDetail {
  ExpDetail(
      {required this.amount,
      required this.detail,
      required this.timestamp,
      required this.date});
  int amount = 0;
  Timestamp timestamp = Timestamp.now();
  String detail = '';
  String date = '';
  factory ExpDetail.fromDB(Map<String, dynamic> snap) => ExpDetail(
        amount: snap["amount"] ?? 0,
        detail: snap['detail'] ?? '',
        timestamp: snap['timestamp'] ?? Timestamp.now(),
        date: snap["date"] ?? '',
      );
}
