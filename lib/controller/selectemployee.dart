import 'package:get/state_manager.dart';

class SelectedEmployee extends GetxController {
  RxInt group = 4.obs;
  RxString id = ''.obs;

  selectEmp(value, empId) {
    group.value = value;
    id.value = empId;
  }
}
