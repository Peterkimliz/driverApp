import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safiri/packages/bloc/package_events.dart';
import 'package:safiri/packages/chat/chat_model.dart';
import 'package:safiri/packages/package.dart';

class PackageRepository {
  final _firebaseFirestore = FirebaseFirestore.instance.collection("packages");
  final _chatRef = FirebaseFirestore.instance.collection("chats");

  final firebaseAuth = FirebaseAuth.instance;

  Future<List<Package>> getPackages({required String type}) async {
    QuerySnapshot query = await _firebaseFirestore.get();
    List<Package> packages = [];

    if (query.docs.isNotEmpty) {
      for (var element in query.docs) {
        print("Elements are ${element}");
        Package package =
            Package.fromJson(element.data() as Map<String, dynamic>);
        packages.add(package);
      }
    }
    return packages;
  }

  sendOffer({required SendOffer type}) async {
    print("type${type.carName}");
    print("type${type.carPlate}");
    await _firebaseFirestore.doc(type.packageId).update({
      "drivers": FieldValue.arrayUnion([
        {
          "id": type.driverId,
          "firstName": type.driverFirstName,
          "lastName": type.driverLastName,
          "phone": type.driverPhone,
          "profile": type.driverPhoto,
          "offer": type.offerPrice,
          "carPlate": type.carPlate,
          "carName": type.carName,
        }
      ])
    });
  }

  sendMessage({required SendMessage type}) async {
    List<String> users = [];
    users.add(FirebaseAuth.instance.currentUser!.uid);
    users.add(type.package.owner!.id!);
    ChatModel chatModel = ChatModel(
      message: type.message,
      date: DateTime.now(),
      receiverId: type.package.owner!.id!,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _chatRef.doc(type.id).set({"users": users}).then((value) {
      _chatRef.doc(type.id).collection("chats").add(chatModel.toJson());
    });
  }

  Future<String> getChatIdInboxes({required user}) async {
    String chatId = "";
    print("users are ${user}");
    await _chatRef.where("users", isEqualTo: user).get().then((value) {
      List data = value.docs;
      var index = data.indexWhere((element) =>
          element["users"].contains(FirebaseAuth.instance.currentUser!.uid));
      chatId = index == -1 ? _chatRef.doc().id : value.docs[index].id;
    });

    return chatId;
  }
}
