import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/functions/getdate.dart';
import 'package:dairyfarmapp/model/adminexpense.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminExpenseController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  AdminExpense expense = AdminExpense();

  @override
  void onInit() {
    super.onInit();
    getExpense();
  }

  getExpense() {
    expense.expenseList.clear();
    var id = getCurrrentDate();

    db.collection("adminExpense").doc(id).get().then((value) {
      if (value.exists) {
        var data = value.data()!;

        for (var element in data["expense"]) {
          expense.expenseList.add(AdminExpList.fromDB(element));
        }
      }
    });
  }

  addExpense(
    String title,
    int amount,
    String detail,
    String date,
  ) {
    // var id = getCurrrentDate();
    db.collection("adminExpense").doc(date).get().then((value) {
      if (value.exists) {
        Map<String, dynamic> data = {
          "date": date,
          "title": title,
          "adminId": _auth.currentUser!.uid,
          "amount": amount,
          "detail": detail,
          "timestamp": Timestamp.now(),
        };

        db.collection("adminExpense").doc(date).update({
          "expense": FieldValue.arrayUnion([data])
        });
      } else {
        Map<String, dynamic> data = {
          "id": date,
          "expense": [
            {
              "date": date,
              "title": title,
              "adminId": _auth.currentUser!.uid,
              "amount": amount,
              "detail": detail,
              "timestamp": Timestamp.now(),
            }
          ]
        };

        db.collection("adminExpense").doc(date).set(data);
      }
      stopLoader();
      getExpense();
    });
  }

  getExpenseDateRange( dates) {
    expense.expenseList.clear();

    for (var date in dates) {
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(date);

      db
          .collection("adminExpense")
          .where("id", isEqualTo: formattedDate)
          .get()
          .then((value) {
        var data = value.docs;

        for (var adminExp in data) {
          for (var adminData in adminExp["expense"]) {
            expense.expenseList.add(AdminExpList.fromDB(adminData));
          }
        }
      });

      log("expense data flitered");

      // expense.expenseList.sort((a, b) {
      //   return a.date.compareTo(b.date);
      // });
      stopLoader();
    }
  }

  searchByTitle(String searchTxt) {
    List<AdminExpList> searchedList = [];
    for (var data in expense.expenseList) {
      if (data.title.toLowerCase().contains(searchTxt.toLowerCase())) {
        searchedList.add(data);
      }
    }
    expense.expenseList.clear();
    expense.expenseList.addAll(searchedList);
    stopLoader();
  }
}
