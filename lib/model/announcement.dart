import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  Announcement(
      {required this.userId,
      required this.detail,
      required this.date,
      required this.timestamp,
      required this.title});
  String userId = "";
  String date = "";

  String title = "";
  String detail = "";

  Timestamp timestamp = Timestamp.now();
  factory Announcement.fromDb(Map<String, dynamic> snap) => Announcement(
        userId: snap["userId"] ?? '',
        detail: snap["detail"] ?? '',
        timestamp: snap["timestamp"] ?? Timestamp.now(),
        title: snap["title"] ?? "",
        date: snap["date"] ?? '',
      );
}
