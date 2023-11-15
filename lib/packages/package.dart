
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

  Package(
      {this.name,
        this.id,
        this.description,
        this.image,
        this.paymentMethod,
        this.price,
        this.status,
        this.startDestination,
        this.endDestination});

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
