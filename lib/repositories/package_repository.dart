import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
