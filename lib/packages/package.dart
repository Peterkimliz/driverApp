import 'package:cloud_firestore/cloud_firestore.dart';

class Package {
  String? name;
  String? description;
  String? price;
  String? id;
  String? image;
  String? paymentMethod;
  String? status;
  bool? hired;
  Destinations? startDestination;
  Destinations? endDestination;
  List<Driver>? drivers;
  Driver? hiredDriver;
  Driver? owner;
  String? riderPlayerId;
  String? driverPlayerId;

  Package(
      {this.name,
      this.id,
      this.description,
      this.image,
      this.paymentMethod,
      this.price,
      this.status,
      this.startDestination,
      this.endDestination,
      this.drivers,
      this.hiredDriver,
      this.owner,
      this.riderPlayerId,
      this.driverPlayerId,
      this.hired});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json["name"],
      hired: json["hired"],
      id: json["id"],
      description: json["description"],
      price: json["offerPrice"],
      image: json["image"],
      paymentMethod: json["paymentMethod"],
      status: json["status"],
      riderPlayerId: json["riderPlayerId"] ?? "",
      driverPlayerId: json["driverPlayerId"] ?? "",
      startDestination: Destinations.fromJson(json["startDestination"]),
      endDestination: Destinations.fromJson(json["endDestination"]),
      hiredDriver:
          json["driver"] == null ? null : Driver.fromJson(json["driver"]),
      owner: json["owner"] == null ? null : Driver.fromJson(json["owner"]),
      drivers: json["drivers"] == null
          ? []
          : List<Driver>.from(json["drivers"].map((e) => Driver.fromJson(e))),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "hired": hired,
        "description": description,
        "price": price,
        "id": id,
        "image": image,
        "paymentMethod": paymentMethod,
        "status": status,
        "driverPlayerId": driverPlayerId,
        "riderPlayerId": riderPlayerId,
      };
}

class Driver {
  String? firstName;
  String? lastName;
  int? offer;
  String? id;
  String? phone;
  String? profile;
  String? carName;
  String? carPlate;

  Driver(
      {this.firstName,
      this.id,
      this.lastName,
      this.phone,
      this.offer,
      this.profile,
      this.carPlate,
      this.carName});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      firstName: json["firstName"],
      id: json["id"],
      lastName: json["lastName"],
      offer: json["offer"],
      profile: json["profile"],
      phone: json["phone"],
      carPlate: json["carPlate"],
      carName: json["carName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "offer": offer,
      "id": id,
      "profile": profile,
      "carName": phone,
      "phone": carName,
      "carPlate": carPlate,
    };
  }
}

class Destinations {
  String? title;
  String? address;
  GeoPoint? latlng;

  Destinations({this.latlng, this.address, this.title});

  factory Destinations.fromJson(Map<String, dynamic> json) => Destinations(
        title: json["title"],
        address: json["address"],
        latlng: json["latlng"],
      );

  Map<String, dynamic> toJson() =>
      {"title": title, "address": address, "latlng": latlng};
}
