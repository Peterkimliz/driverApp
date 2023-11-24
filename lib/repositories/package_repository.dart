import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safiri/packages/bloc/package_events.dart';
import 'package:safiri/packages/chat/chat_model.dart';
import 'package:safiri/packages/package.dart';

import '../home /places_search_result.dart';

class PackageRepository {
  final _firebaseFirestore = FirebaseFirestore.instance.collection("packages");
  final _chatRef = FirebaseFirestore.instance.collection("chats");

  final firebaseAuth = FirebaseAuth.instance;

  Future<List<Package>> getPackages(
      {required bool hired, List<PlacesSearchResult>? location}) async {
    try {
      Query<Map<String, dynamic>> queries = _firebaseFirestore;

      // if (hired == false) {
      //   queries = queries.where("hired", isEqualTo: false);
      // } else if (hired == true) {
      //   queries = queries.where("hired", isEqualTo: true).where("driver.id",
      //       isEqualTo: FirebaseAuth.instance.currentUser!.uid);
      // } else

      // if (location!.isNotEmpty) {
      //   print(
      //       "Location is ${GeoPoint(location[1].geometry!.location.lat, location[1].geometry!.location.lng)}");
      //
      //   queries = queries
      //       .where("start",
      //           isEqualTo: GeoPoint(location[0].geometry!.location.lat,
      //               location[0].geometry!.location.lng))
      //       .where("end",
      //           isLessThanOrEqualTo: GeoPoint(
      //               location[1].geometry!.location.lat,
      //               location[1].geometry!.location.lng));
      // }
      QuerySnapshot query = await queries.get();
      List<Package> packages = [];
      if (query.docs.isNotEmpty) {
        for (var element in query.docs) {
          print("Elements are ${element}");
          Package package =
              Package.fromJson(element.data() as Map<String, dynamic>);
          packages.add(package);
        }
      }
      print("package length is ${packages.length}");
      return packages;
    } catch (e) {
      return [];
    }
  }

  sendOffer({required SendOffer type}) async {
    // var driverPlayerId = await checkUserHasPackages();
    await _firebaseFirestore.doc(type.package.id).update({
      // "driverPlayerId": driverPlayerId,
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
    }).then((value) {
      // sendChatNotification(
      //     message: "${type.driverFirstName} has sent you an offer",
      //     screen: "package",
      //     type: type.package,
      //     chatid: "");
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
      _chatRef
          .doc(type.id)
          .collection("chats")
          .add(chatModel.toJson())
          .then((value) {
        // sendChatNotification(
        //     message: type.message,
        //     screen: "chat",
        //     type: type.package,
        //     chatid: type.id);
      });
    });
  }

  Future<String> getChatIdInboxes({required user}) async {
    String chatId = "";
    await _chatRef.where("users", isEqualTo: user).get().then((value) {
      List data = value.docs;
      var index = data.indexWhere((element) =>
          element["users"].contains(FirebaseAuth.instance.currentUser!.uid));
      chatId = index == -1 ? _chatRef.doc().id : value.docs[index].id;
    });

    return chatId;
  }

  changeStatus({required Package type}) async {
    await _firebaseFirestore.doc(type.id).update({"status": "completed"});
  }

// updatePlayerId(String uid) async {
//   print("Updating player  iD");
//   final String? osUserID = await generateOneSignalId();
//   var collection = FirebaseFirestore.instance
//       .collection('packages')
//       .where("driver.id", isEqualTo: uid);
//   var querySnapshots = await collection.get();
//   for (var doc in querySnapshots.docs) {
//     await doc.reference.update({
//       "driverPlayerId": osUserID,
//     });
//   }
// }

// Future<String?> generateOneSignalId() async {
//   final status = await OneSignal.shared.getDeviceState();
//   return status?.userId;
// }

// Future<String?> checkUserHasPackages() async {
//   var collection = _firebaseFirestore.where("driver.id",
//       isEqualTo: firebaseAuth.currentUser!.uid);
//   var querySnapshots = await collection.get();
//   if (querySnapshots.docs.isEmpty) {
//     final status = await OneSignal.shared.getDeviceState();
//     return status?.userId;
//   } else {
//     return querySnapshots.docs[0]["riderPlayerId"];
//   }
// }

// void sendChatNotification(
//     {required String message,
//     required screen,
//     required Package type,
//     required String chatid}) async {
//   var notification = OSCreateNotification(
//     playerIds: [type.riderPlayerId!],
//     content: message,
//     androidLargeIcon: FirebaseAuth.instance.currentUser?.photoURL,
//     additionalData: {
//       "screen": screen,
//       "type": type.toJson(),
//       "message": message,
//       "chatId": chatid,
//     },
//     heading: type.owner?.firstName,
//   );
//
//   sendNotification(notification: notification);
// }

// void sendNotification({required OSCreateNotification notification}) async {
//   await OneSignal.shared.postNotification(notification);
// }
}
