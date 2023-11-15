import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safiri/packages/bloc/package_events.dart';
import 'package:safiri/packages/package.dart';

class PackageRepository {
  final firebaseFirestore = FirebaseFirestore.instance.collection("packages");

  final firebaseAuth = FirebaseAuth.instance;

  Future<List<Package>> getPackages({required String type}) async {
    QuerySnapshot query =
        await firebaseFirestore.where("status", isEqualTo: type).get();
    List<Package> packages = [];
    print("Elements are ${query.docs}");
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

    await firebaseFirestore.doc(type.packageId).update({
      "drivers": FieldValue.arrayUnion([
        {
          "id": type.driverId,
          "firstName": type.driverFirstName,
          "lastName": type.driverLastName,
          "phone": type.driverPhone,
          "profile": type.driverPhoto,
          "offer": type.offerPrice
        }
      ])
    });
  }
}
