import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/functions/getdate.dart';
import 'package:dairyfarmapp/model/announcement.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AnnouncementController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Announcement anoucement = Announcement(
      userId: "", detail: "", timestamp: Timestamp.now(), title: "", date: '');

  RxList<Announcement> adminlst = <Announcement>[].obs;
  List<Announcement> customerlst = <Announcement>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAnnouncementByAdmin(getCurrrentDate());
    getAnnouncementByCustomer(getCurrrentDate());
  }

  getAnnouncementByAdmin(String id) {
    adminlst.clear();
    db.collection("announcement").doc(id).get().then((value) {
      if (value.exists) {
        var data = value.data();

        if (data!["admins"] != null) {
          for (var element in data["admins"]) {
            adminlst.add(Announcement.fromDb(element));
          }
        }
      }
    });
    db.collection("users").doc(_auth.currentUser!.uid).get().then((value) {
      if (value.exists) {
        var data = value.data()!;

        if (data["accouncement"] != null) {
          for (var element in data["accouncement"]) {
            if (element["date"] == id) {
              adminlst.add(Announcement.fromDb(element));
            }
          }
        }
      }
    });
    stopLoader();
  }

//get admin annoucement date range

  getAnnouncementByAdminDateRande(dates) {
    try {
      adminlst.clear();

      for (var date in dates) {
        var formatter = DateFormat('yyyy-MM-dd');
        var formattedDate = formatter.format(date);
        db.collection("announcement").doc(formattedDate).get().then((value) {
          if (value.exists) {
            var data = value.data();

            if (data!["admins"] != null) {
              for (var element in data["admins"]) {
                adminlst.add(Announcement.fromDb(element));
              }
            }
          }
        });
        db.collection("users").doc(_auth.currentUser!.uid).get().then((value) {
          if (value.exists) {
            var data = value.data()!;

            if (data["accouncement"] != null) {
              for (var element in data["accouncement"]) {
                if (element["date"] == formattedDate) {
                  adminlst.add(Announcement.fromDb(element));
                }
              }
            }
          }
        });
      }

      // adminlst.addAll(annData);
      stopLoader();
    } catch (e) {
      log(e.toString());
      stopLoader();
    }
  }

  getAnnouncementByCustomer(String id) {
    customerlst.clear();
    var id = getCurrrentDate();
    db.collection("announcement").doc(id).get().then((value) {
      if (value.exists) {
        var data = value.data();

        if (data!["customers"] != null) {
          for (var element in data["customers"]) {
            if (element["date"] == id) {
              customerlst.add(Announcement.fromDb(element));
            }
          }
        }
      }
    });
    stopLoader();
  }

//get customer announce date range
//get admin annoucement date range

  getAnnouncementByCustomerDateRande(dates) {
    try {
      customerlst.clear();

      for (var date in dates) {
        var formatter = DateFormat('yyyy-MM-dd');
        var formattedDate = formatter.format(date);
        db.collection("announcement").doc(formattedDate).get().then((value) {
          if (value.exists) {
            var data = value.data();

            if (data!["customers"] != null) {
              for (var element in data["customers"]) {
                customerlst.add(Announcement.fromDb(element));
              }
            }
          }
        });
      }

      // adminlst.addAll(annData);
      stopLoader();
    } catch (e) {
      log(e.toString());
      stopLoader();
    }
  }

  addAnnouncementByAdmin(String title, String detail) {
    adminlst.clear();

    var id = getCurrrentDate();
    Map<String, dynamic> data = {
      "title": title,
      "detail": detail,
      "date": getCurrrentDate(),
      "userId": _auth.currentUser!.uid.toString(),
      "timestamp": Timestamp.now(),
    };
    db.collection("announcement").doc(id).get().then((value) {
      if (value.exists) {
        db.collection("announcement").doc(id).update({
          "admins": FieldValue.arrayUnion([data])
        }).then((value) {
          showBanner("Sent", "Announcement sent");

          stopLoader();
        });
      } else {
        db.collection("announcement").doc(id).set({
          "admins": [data]
        }).then((value) {
          showBanner("Sent", "Announcement sent");

          stopLoader();
        });
      }
    });
  }

  addSpecificAnnounce(String customerId, String title, String detail) {
    Map<String, dynamic> annData = {
      "title": title,
      "detail": detail,
      "date": getCurrrentDate(),
      "userId": _auth.currentUser!.uid.toString(),
      "timestamp": Timestamp.now(),
    };
    db.collection("users").doc(customerId).get().then((value) {
      if (value.exists) {
        var data = value.data()!;

        if (data["accouncement"] != null) {
          db.collection("users").doc(customerId).update({
            "accouncement": FieldValue.arrayUnion([annData])
          }).then((value) {
            showBanner("Sent", "Announcement sent");

            stopLoader();
          });
        } else {
          db.collection("users").doc(customerId).update({
            "accouncement": [annData]
          }).then((value) {
            showBanner("Sent", "Announcement sent");

            stopLoader();
          });
        }
      }
    });
  }

  addAnnouncementByCustomer(String title, String detail) {
    var id = getCurrrentDate();
    Map<String, dynamic> data = {
      "title": title,
      "detail": detail,
      "date": getCurrrentDate(),
      "userId": _auth.currentUser!.uid.toString(),
      "timestamp": Timestamp.now(),
    };
    db.collection("announcement").doc(id).get().then((value) {
      if (value.exists) {
        db.collection("announcement").doc(id).update({
          "customers": FieldValue.arrayUnion([data])
        }).then((value) {
          showBanner("Sent", "Announcement sent");

          stopLoader();
        });
      } else {
        db.collection("announcement").doc(id).set({
          "customers": [data]
        }).then((value) {
          showBanner("Sent", "Announcement sent");

          stopLoader();
        });
      }
    });
  }
}
