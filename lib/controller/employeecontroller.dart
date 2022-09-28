import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/model/employeemodel.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:get/get.dart';

class EmployeeController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  Employee employee = Employee();

  @override
  void onInit() {
    super.onInit();
    getEmployees();
  }

  changeStatus(String customerID, bool status) {
    db
        .collection("users")
        .doc(customerID)
        .update({"status": !status}).then((value) {
      getEmployees();
    });
  }

  getEmployees() {
    employee.lst.clear();
    db
        .collection("users")
        .where("role", isEqualTo: "employee")
        .get()
        .then((value) {
      var data = value.docs;

      for (var user in data) {
        var userData = user.data();
        employee.lst.add(EmployeeList.fromDB(userData));
        // customer.lst.add(CustomerList.fromDB(user.data()));

      }
      employee.lst.sort(
        (a, b) {
          if (b.status) {
            return 1;
          }
          return -1;
        },
      );
      stopLoader();
    });
  }

  searchUserbyName(String name) {
    List<EmployeeList> filteredList = [];
    for (var user in employee.lst) {
      if (user.name.toLowerCase().contains(name.toLowerCase())) {
        filteredList.add(user);
      }
    }
    employee.lst.clear();

    employee.lst.addAll(filteredList);
    stopLoader();
  }
}
