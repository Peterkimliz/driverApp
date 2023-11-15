class Package {
  String? name;
  String? description;
  String? price;
  String? id;
  String? image;
  String? paymentMethod;
  String? status;
  Destinations? startDestination;
  Destinations? endDestination;
  List<Driver>? drivers;

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
      this.drivers});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json["name"],
      id: json["id"],
      description: json["description"],
      price: json["offerPrice"],
      image: json["image"],
      paymentMethod: json["paymentMethod"],
      status: json["status"],
      startDestination: Destinations.fromJson(json["startDestination"]),
      endDestination: Destinations.fromJson(json["endDestination"]),
      drivers: json["drivers"] == null
          ? []
          : List<Driver>.from(json["drivers"].map((e) => Driver.fromJson(e))),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "id": id,
        "image": image,
        "paymentMethod": paymentMethod,
        "status": status,
      };
}

class Driver {
  String? firstName;
  String? lastName;
  int? offer;
  String? id;
  String? phone;
  String? profile;

  Driver({
    this.firstName,
    this.id,
    this.lastName,
    this.phone,
    this.offer,
    this.profile,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      firstName: json["firstName"],
      id: json["id"],
      lastName: json["lastName"],
      offer: json["offer"],
      profile: json["profile"],
      phone: json["phone"],
    );
  }
}

class Destinations {
  String? title;
  String? address;
  Location? latlng;

  Destinations({this.latlng, this.address, this.title});

  factory Destinations.fromJson(Map<String, dynamic> json) => Destinations(
        title: json["title"],
        address: json["address"],
        latlng: Location.fromJson(json["latlng"]),
      );

  Map<String, dynamic> toJson() =>
      {"title": title, "address": address, "latlng": latlng!.toJson()};
}

class Location {
  String? title;
  List<double>? coordinates;

  Location({this.coordinates, this.title});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        title: json["title"],
        coordinates: List<double>.from(json["coordinates"].map((e) => e)),
      );

  Map<String, dynamic> toJson() => {"title": title, "coordinates": coordinates};
}
