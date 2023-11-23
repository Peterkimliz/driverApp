class PlacesSearchResult {
  String? formattedAddress;
  Geometry? geometry;
  String? name;
  String? placeId;

  PlacesSearchResult({
    this.formattedAddress,
    this.geometry,
    this.name,
    this.placeId,
  });

  factory PlacesSearchResult.fromJson(Map<String, dynamic> json) =>
      PlacesSearchResult(
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        name: json["name"],
        placeId: json["place_id"],
      );
}

class Geometry {
  Location? location;

  Geometry({
    this.location,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
      );
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );
}
