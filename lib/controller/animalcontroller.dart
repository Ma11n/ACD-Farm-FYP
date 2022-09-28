import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/functions/getdate.dart';
import 'package:dairyfarmapp/model/animal.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AnimalController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Animals animals = Animals(
    id: "",
    age: "",
    catergory: "",
    gender: "",
    pic: "",
    puchasedCity: "",
    purchasedPrice: 0,
    remarks: "",
    sellPrice: 0,
    srNo: "",
    status: true,
    timestamp: Timestamp.now(),
    disableReason: '',
    adminId: '',
    parentId: '',
  );

  RxList<Animals> lst = <Animals>[].obs;

  RxList<Animals> children = <Animals>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAnimals();
  }

  getAnimals() {
    lst.clear();
    db.collection("animals").get().then((value) {
      if (value.docs.isNotEmpty) {
        var data = value.docs;
        for (var element in data) {
          lst.add(Animals.fromDB(element.data()));
        }

        lst.sort(
          (a, b) {
            if (b.status) {
              return 1;
            }
            return -1;
          },
        );
      }
    });
  }

  addAnimals(
      String srNumber,
      String category,
      int purchasedPrice,
      String age,
      String purchasedCity,
      String gender,
      String remarks,
      String? pic,
      String? animalID) async {
    if (animalID == null) {
      Map<String, dynamic> animalData = {
        "srNo": srNumber,
        "category": category,
        "purchasedPrice": purchasedPrice,
        "age": age,
        "purchasedCity": purchasedCity,
        "gender": gender,
        "remarks": (remarks != '') ? remarks : "",
        "pic": (pic != null || pic != "") ? pic : "",
        "status": true,
        "disableReason": "",
        "sellPrice": 0,
        "adminId": _auth.currentUser!.uid,
        "timestamp": Timestamp.now(),
      };

      await db.collection("animals").add(animalData).then((value) async {
        await db
            .collection("animals")
            .doc(value.id)
            .update({"id": value.id}).then((value) {
          showBanner("Success!", "Animal Added");
          stopLoader();
          getAnimals();
        });
      });
    } else {
      Map<String, dynamic> animalData = {
        "srNo": srNumber,
        "category": category,
        "purchasedPrice": purchasedPrice,
        "age": age,
        "purchasedCity": purchasedCity,
        "parentId": animalID,
        "gender": gender,
        "disableReason": "",
        "remarks": (remarks != '') ? remarks : "",
        "pic": (pic != '' || pic != null) ? pic : "",
        "status": true,
        "sellPrice": 0,
        "adminId": _auth.currentUser!.uid,
        "timestamp": Timestamp.now(),
      };

      await db.collection("animals").doc(animalID).update({
        "children": FieldValue.arrayUnion([animalData])
      }).then((value) {
        showBanner("Success", "Child Added");

        viewChildren(animalID);
        stopLoader();
      });
    }
  }

  changeAnimalStatus(String id, bool status, String? selectReson,
      String? Svalue, String parent) async {
    // for (var element in children) {
    //   if (element.id == id) {
    //     element.status = !status;
    //     print(element.status);
    //   }
    // }

    db.collection("animals").doc(parent).get().then((value) {
      if (value.exists) {
        var data = value.data();

        for (var element in data!["children"]) {
          if (element["srNo"] == id) {
            db.collection("animals").doc(parent).update({
              "children": FieldValue.arrayRemove([element])
            }).then((value) {
              for (var i = 0; i < children.length; i++) {
                if (children[i].srNo == id) {
                  Map<String, dynamic> animalData = {
                    "srNo": children[i].srNo,
                    "category": children[i].catergory,
                    "purchasedPrice": children[i].purchasedPrice,
                    "age": children[i].age,
                    "purchasedCity": children[i].puchasedCity,
                    "gender": children[i].gender,
                    "disableReason": selectReson == "Death" ? Svalue! : "",
                    "remarks": children[i].remarks,
                    "pic": children[i].pic,
                    "status": !children[i].status,
                    "sellPrice": selectReson == "Salled"
                        ? Svalue!
                        : children[i].sellPrice,
                    "adminId": children[i].adminId,
                    "timestamp": children[i].timestamp,
                  };

                  db.collection("animals").doc(parent).update({
                    "children": FieldValue.arrayUnion([animalData])
                  }).then((value) {
                    stopLoader();
                    viewChildren(parent);
                  });

                  break;
                }
              }
            });
          }
        }
      }
    });
  }

  changeStatus(String id, bool status, String? selectReson, String? value) {
    if (value != null) {
      if (selectReson == "Salled") {
        db.collection("animals").doc(id).update(
            {"status": !status, "sallPrice": int.parse(value)}).then((value) {
          getAnimals();
        });
      }
      db
          .collection("animals")
          .doc(id)
          .update({"status": !status, "disableReason": value}).then((value) {
        getAnimals();
      });
    } else {
      db.collection("animals").doc(id).update({
        "status": !status,
      }).then((value) {
        getAnimals();
      });
    }
  }

  searchAnimalbySrNo(String text) {
    lst.clear();
    db.collection("animals").where("srNo", isEqualTo: text).get().then((value) {
      if (value.docs.isNotEmpty) {
        var data = value.docs;
        for (var element in data) {
          lst.add(Animals.fromDB(element.data()));
        }
      }
    });
    stopLoader();
  }

// view journal

  viewjournal(String animalid) {
    animals.journalList.clear();
    var date = getCurrrentDate();
    db.collection("animals").doc(animalid).get().then((value) {
      if (value.exists) {
        var data = value.data()!;

        for (var element in data["journal"]) {
          if (element["date"] == date) {
            animals.journalList.add(Journal.fromDB(element));
          }
        }
      }
    });
  }
  // view journal by date

  viewJournalByDate(String animalid, List dates) {
    animals.journalList.clear();
    for (var date in dates) {
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(date);
      db.collection("animals").doc(animalid).get().then((value) {
        if (value.exists) {
          var data = value.data()!;
          for (var element in data["journal"]) {
            print(element);
            if (element["date"] == formattedDate) {
              print(element);
              animals.journalList.add(Journal.fromDB(element));
            }
          }
        }
      });
    }
    stopLoader();
  }

  //Add Journal

  addJournal(String title, String detail, String animalId) {
    Map<String, dynamic> data = {
      "adminId": _auth.currentUser!.uid,
      "title": title,
      "detail": detail,
      "date": getCurrrentDate(),
      "timestamp": Timestamp.now(),
    };

    db.collection("animals").doc(animalId).update({
      "journal": FieldValue.arrayUnion([data])
    }).then((value) {
      viewjournal(animalId);
      stopLoader();
    });
  }

  viewChildren(String animalId) {
    children.clear();

    db.collection("animals").doc(animalId).get().then((value) {
      if (value.exists) {
        var data = value.data()!;

        for (var element in data["children"]) {
          children.add(Animals.fromDB(element));
        }
      }
    });
  }

  updateAnimal(
      String srNumber,
      String category,
      int purchasedPrice,
      String age,
      String purchasedCity,
      String gender,
      String remarks,
      String pic,
      String? animalID) {
    Map<String, dynamic> animalData = {
      "srNo": srNumber,
      "category": category,
      "purchasedPrice": purchasedPrice,
      "age": age,
      "purchasedCity": purchasedCity,
      "gender": gender,
      "remarks": (remarks != '') ? remarks : "",
      "pic": (pic != '') ? pic : "",
      "status": true,
      "disableReason": "",
      "sellPrice": 0,
      "adminId": _auth.currentUser!.uid,
      "timestamp": Timestamp.now(),
    };

    db.collection("animals").doc(animalID).update(animalData).then((value) {
      stopLoader();
      showBanner("Success", "Animal Updated");
    });
  }

  updateChildren(
      String srNumber,
      String category,
      int purchasedPrice,
      String age,
      String purchasedCity,
      String gender,
      String parentId,
      String remarks,
      String pic,
      String? animalID) {
    Map<String, dynamic> animalData = {
      "srNo": srNumber,
      "category": category,
      "purchasedPrice": purchasedPrice,
      "age": age,
      "purchasedCity": purchasedCity,
      "gender": gender == "" ? "male" : gender,
      "remarks": (remarks != '') ? remarks : "",
      "pic": (pic != '') ? pic : "",
      "status": true,
      "disableReason": "",
      "sellPrice": 0,
      "adminId": _auth.currentUser!.uid,
      "timestamp": Timestamp.now(),
    };

    db.collection("animals").doc(parentId).get().then((value) {
      if (value.exists) {
        var detail = value.data();

        var childrenData = detail!["children"];
        var updatedChildren = [];
        for (var element in childrenData) {
          if (element["srNo"] == srNumber) {
            updatedChildren.add(animalData);
          } else {
            updatedChildren.add(element);
          }
        }

        db
            .collection("animals")
            .doc(parentId)
            .update({"children": updatedChildren}).then((value) {
          stopLoader();
          showBanner("Success", "Child Updated");
        });
      }
    });

    // db.collection("animals").doc(animalID).update(animalData).then((value) {
    //   stopLoader();
    // });
  }
}
