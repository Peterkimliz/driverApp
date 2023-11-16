import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String? id;
  final String? message;
  final DateTime? date;
  final String? senderId;
  final String? receiverId;

  ChatModel({this.id, this.message, this.date, this.receiverId, this.senderId});

  factory ChatModel.fromJson(DocumentSnapshot json) {
    return ChatModel(
      message: json["message"],
      id: json.id,
      date: json["date"].toDate(),
      senderId: json["senderId"],
      receiverId: json["receiverId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "date": date,
        "senderId": senderId,
        "receiverId": receiverId,
      };
}
