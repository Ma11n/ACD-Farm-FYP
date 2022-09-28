import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

// To parse this JSON data, do
//
//     final milk = milkFromJson(jsonString);

class Milk {
  RxString id = "".obs;
  RxInt price = 0.obs;
  RxDouble remainingMilk = 0.0.obs;
  RxDouble totalMilk = 0.0.obs;
  List<Customers> customers = <Customers>[].obs;
  List<Admins> admins = <Admins>[].obs;

  setValue(Map<String, dynamic> snapshot) {
    price.value = snapshot["price"] ?? 0;
    remainingMilk.value = snapshot["remainingMilk"] ?? 0.0;
    totalMilk.value = snapshot["totalMilk"] ?? 0.0;
  }

  Map<String, dynamic> toJson() => {
        "price": price.value,
        "remainingMilk": remainingMilk.value,
        "totalMilk": totalMilk.value,
        "customers": List<dynamic>.from(customers.map((x) => x.toJson())),
        "admins": List<dynamic>.from(admins.map((x) => x.toJson())),
      };
}

class Admins {
  Admins({
    required this.adminId,
    required this.milkQuantity,
    required this.milkSource,
    required this.timestamp,
  });
  String adminId;
  double milkQuantity;
  String milkSource;
  Timestamp timestamp;

  factory Admins.fromMap(Map<String, dynamic> snap) {
    return Admins(
      adminId: snap["adminId"] ?? '',
      milkQuantity: snap["milkQuantity"] ?? 0.0,
      milkSource: snap["milkSource"] ?? '',
      timestamp: snap["timestamp"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "adminId": adminId,
        "milkQuantity": milkQuantity,
        "milkSource": milkSource,
        "timestamp": timestamp,
      };
}

class Customers {
  Customers({
    required this.adminId,
    required this.customerId,
    required this.emplyeeId,
    required this.price,
    required this.milkQuantity,
    required this.timestamp,
  });

  String adminId;
  String customerId;
  String emplyeeId;
  int price;
  double milkQuantity;
  Timestamp timestamp;

  factory Customers.fromDB(Map<String, dynamic> snap) => Customers(
        adminId: snap["adminId"] ?? '',
        customerId: snap["customerId"] ?? '',
        price: snap['price'] ?? 0,
        emplyeeId: snap["emplyeeId"] ?? '',
        milkQuantity: snap["milkQuantity"] ?? 0.0,
        timestamp: snap["timestamp"] ?? Timestamp.now(),
      );

  Map<String, dynamic> toJson() => {
        "adminId": adminId,
        "customerId": customerId,
        "emplyeeId": emplyeeId,
        "milkQuantity": milkQuantity,
        "timestamp": timestamp,
      };
}
