import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyfarmapp/model/customermodel.dart';
import 'package:dairyfarmapp/util/dialog.dart';
import 'package:dairyfarmapp/util/loader.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  Customer customer = Customer();

  RxList<CustomerList> enabledUser = <CustomerList>[].obs;
  RxList<CustomerList> disableUser = <CustomerList>[].obs;
  @override
  void onInit() {
    super.onInit();
    getCusomers();
    // gettingEnabledCustomer();
    // gettingDisableCustomer();
  }

  gettingEnabledCustomer() {
    var lst = customer.lst;
    enabledUser.clear();
    for (var element in lst) {
      if (element.status == true && element.role == "customer") {
        enabledUser.add(element);
      }
    }
  }

  gettingDisableCustomer() {
    // var disabledList = [];
    var lst = customer.lst;
    disableUser.clear();
    for (var element in lst) {
      if (element.status == false && element.role == "customer") {
        // disabledList.add(element);
        disableUser.add(element);
      }
    }
    // return disabledList;
  }

  changeStatus(String customerID, bool status) {
    db
        .collection("users")
        .doc(customerID)
        .update({"status": !status}).then((value) {
      getCusomers();
      showBanner("Changed", "User status changed");
    });
  }

  getCusomers() {
    customer.lst.clear();
    db
        .collection("users")
        .where("role", isEqualTo: "customer")
        .get()
        .then((value) {
      var data = value.docs;

      for (var user in data) {
        var userData = user.data();
        customer.lst.add(CustomerList.fromDB(userData));
        // customer.lst.add(CustomerList.fromDB(user.data()));

      }
      customer.lst.sort(
        (a, b) {
          if (b.status) {
            return 1;
          }
          return -1;
        },
      );
      gettingDisableCustomer();
      gettingEnabledCustomer();

      stopLoader();
    });
  }

  searchUserbyName(String name, bool forEnaled) {
    List<CustomerList> filteredList = [];
    for (var user in customer.lst) {
      if (user.name.toLowerCase().contains(name.toLowerCase())) {
        filteredList.add(user);
      }
    }
    customer.lst.clear();

    customer.lst.addAll(filteredList);
    stopLoader();
  }
}
