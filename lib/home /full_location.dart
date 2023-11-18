import 'package:latlong2/latlong.dart';

class FullLocation {
  String title;
  String address;
  LatLng latlng;

  FullLocation(
      {required this.latlng, required this.address, required this.title});

  Map<String, dynamic> toJson() =>
      {"title": title, "address": address, "latlng": latlng.toJson()};
}
// extension ConvertToFullLocation on Query$getPlaces$getPlaces {
//   FullLocation toFullLocation() {
//     return FullLocation(
//         latlng: LatLng(point.lat, point.lng),
//         address: address,
//         title: title ?? '');
//   }
//}
