import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/functions/getdate.dart';
import 'package:dairyfarmapp/model/milk.dart';
import 'package:dairyfarmapp/model/milkforcustomer.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class MilkController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Milk milk = Milk();
  CustomerMilk customerMilk = CustomerMilk();
  @override
  void onInit() {
    super.onInit();
    getMilkFromAdmin();
    getMilkDetail();
    getCustomersMilk();
  }

  getMilkForCustomer(String id) async {
    var date = getCurrrentDate();
    customerMilk.customers.clear();

    await db.collection("milk").doc(date).get().then((value) {
      if (value.exists) {
        var data = value.data();
        if (data!["customers"] != null) {
          for (var element in data['customers']) {
            if (element['customerId'] == id) {
              customerMilk.customers.add(Customers.fromDB(element));
            }
          }
        }
      }
      stopLoader();
    });
  }

  getCustomerMilkRange(List dates, String id) async {
    try {
      customerMilk.customers.clear();
      for (var element in dates) {
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(element);
        await db
            .collection("milk")
            .where("id", isEqualTo: formattedDate)
            .get()
            .then((value) {
          var data = value.docs;

          for (var milkData in data) {
            for (var customerData in milkData["customers"]) {
              if (customerData["customerId"] == id) {
                customerMilk.customers.add(Customers.fromDB(customerData));
              }
            }
          }

          stopLoader();
          log("Milk data flitered");
        });
        milk.customers.sort((a, b) {
          return a.timestamp.compareTo(b.timestamp);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getMilkDetail() async {
    String id = getCurrrentDate();

    db.collection("milk").doc(id).get().then((value) {
      if (value.exists) {
        var data = value.data()!;
        // milk.price.value = data["price"] ?? 0;
        // milk.totalMilk.value = data["totalMilk"] ?? 0;

        milk.setValue(data);
      }
    });

    // milk.getMilk(result!);
  }

  addMilk(double quatity, String source) async {
    String id = getCurrrentDate();

    await db.collection("milk").doc(id).get().then((value) async {
      if (value.exists) {
        Map<String, dynamic> milkDate = {
          // "totalMilk": quatity,
          // "data": [
          //   {
          "adminId": auth.currentUser!.uid,
          "milkQuantity": quatity,
          "milkSource": source,
          "timestamp": Timestamp.now()
          // }
          // ]
        };

        await db.collection("milk").doc(id).update({
          'admins': FieldValue.arrayUnion([milkDate])
        }).then((value) async {
          await db.collection('milk').doc(id).update({
            "totalMilk": FieldValue.increment(quatity),
            "remainingMilk": FieldValue.increment(quatity),
          });
        });

        stopLoader();
      } else {
        Map<String, dynamic> milkDate = {
          "totalMilk": quatity,
          "remainingMilk": quatity,
          "id": id,
          "admins": [
            {
              "adminId": auth.currentUser!.uid,
              "milkQuantity": quatity,
              "milkSource": source,
              "timestamp": Timestamp.now()
            }
          ]
        };
        db.collection('milk').doc(id).set(milkDate);
        stopLoader();
      }
      getMilkDetail();
      getMilkFromAdmin();
    });
  }

  addPrice(int price) {
    String id = getCurrrentDate();

    if (milk.totalMilk.value > 0) {
      db.collection("milk").doc(id).update({"price": price}).then((value) {
        getMilkDetail();
        getMilkFromAdmin();
      });
    }
    stopLoader();
  }

  sellMilk(String customerId, String empId, double quantity, RxInt price) {
    String id = getCurrrentDate();

    if (milk.remainingMilk > 0) {
      Map<String, dynamic> data = {
        "customerId": customerId,
        "price": price.value,
        "emplyeeId": empId,
        "adminId": auth.currentUser!.uid,
        "milkQuantity": quantity,
        "timestamp": Timestamp.now(),
      };
      db.collection("milk").doc(id).update({
        "customers": FieldValue.arrayUnion([data])
      }).then((value) {
        double leftmilk = milk.remainingMilk.value - quantity;

        db.collection("milk").doc(id).update({"remainingMilk": leftmilk});
        getMilkDetail();
        getMilkFromAdmin();
      });
      getCustomersMilk();
    }

    showBanner("Added", "Sell Added");
    stopLoader();
  }

  //get milk added by admin

  getMilkFromAdmin() {
    String id = getCurrrentDate();

    milk.admins.clear();

    db.collection("milk").doc(id).get().then((value) {
      if (value.exists) {
        var data = value.data()!;
        if (data["admins"] != null) {
          for (var element in data["admins"]) {
            milk.admins.add(Admins.fromMap(element));
          }
        }
      }
    });
  }

  getMilkFromAdminRange(List dates) async {
    try {
      milk.admins.clear();
      for (var element in dates) {
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(element);
        await db
            .collection("milk")
            .where("id", isEqualTo: formattedDate)
            .get()
            .then((value) {
          var data = value.docs;

          for (var milkData in data) {
            for (var adminData in milkData["admins"]) {
              milk.admins.add(Admins.fromMap(adminData));
            }
          }

          stopLoader();
          log("Milk data flitered");
        });
        milk.admins.sort((a, b) {
          return a.timestamp.compareTo(b.timestamp);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getMilkToCustomersRange(List dates) async {
    try {
      milk.customers.clear();
      for (var element in dates) {
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(element);
        await db
            .collection("milk")
            .where("id", isEqualTo: formattedDate)
            .get()
            .then((value) {
          var data = value.docs;

          for (var milkData in data) {
            for (var adminData in milkData["customers"]) {
              milk.customers.add(Customers.fromDB(adminData));
            }
          }

          stopLoader();
          log("Milk data flitered");
        });
        milk.customers.sort((a, b) {
          return a.timestamp.compareTo(b.timestamp);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getCustomersMilk() {
    milk.customers.clear();

    String id = getCurrrentDate();

    db.collection("milk").doc(id).get().then((value) {
      if (value.exists) {
        var data = value.data()!;
        if (data["customers"] != null) {
          for (var element in data["customers"]) {
            milk.customers.add(Customers.fromDB(element));
          }
        }
      }
      stopLoader();
    });
  }
}
