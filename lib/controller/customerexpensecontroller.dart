import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/functions/getdate.dart';
import 'package:dairyfarmapp/model/customerexpense.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class CustomerExpenseController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  CustomerExpense expense = CustomerExpense();
  @override
  void onInit() {
    super.onInit();
    getExpenseData();
  }

  getExpenseData() {
    expense.expensesList.clear();
    var id = getCurrrentDate();
    var userId = _auth.currentUser!.uid;
    db.collection("expense").doc(userId).get().then((value) {
      var data = value.data();

      for (var element in data!['expense']) {
        if (element['date'] == id) {
          expense.expensesList.add(ExpDetail.fromDB(element));
        }
      }
    });
  }

  addExpense(
    String title,
    String date,
    int amount,
    String detail,
  ) {
    // required this.amount,
    //   required this.detail,
    //   required this.timestamp,
    //   required this.date
    var id = _auth.currentUser!.uid;
    db.collection("customerExpense").doc(id).get().then((value) {
      if (value.exists) {
        Map<String, dynamic> expenselst = {
          "title": title,
          "amount": amount,
          "detail": detail,
          "timestamp": Timestamp.now(),
          "date": date,
        };

        db.collection("customerExpense").doc(id).update({
          "expense": FieldValue.arrayUnion([expenselst])
        });
        stopLoader();
      } else {
        Map<String, dynamic> expenselst = {
          "id": id,
          "expense": [
            {
              "amount": amount,
              "detail": detail,
              "timestamp": Timestamp.now(),
              "date": date,
            }
          ]
        };

        db.collection("customerExpense").doc(id).set(expenselst);
      }
      stopLoader();
      getExpenseData();
    });
  }

  getExpenseFromDateRange(List dates) async {
    try {
      expense.expensesList.clear();
      for (var element in dates) {
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(element);
        await db
            .collection("customerExpense")
            .doc(_auth.currentUser!.uid)
            .get()
            .then((value) {
          var data = value.data();

          for (var expenseData in data!["expense"]) {
            if (expenseData["date"] == formattedDate) {
              expense.expensesList.add(ExpDetail.fromDB(expenseData));
            }
          }

          stopLoader();
          log("Milk data flitered");
        });
        expense.expensesList.sort((a, b) {
          return a.date.compareTo(b.date);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
