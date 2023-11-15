import 'package:equatable/equatable.dart';

abstract class InputsEvents extends Equatable {}

class SearchPackage extends InputsEvents {
  final String name;

  SearchPackage({required this.name});

  @override
  List<Object?> get props => [name];
}

class SendOffer extends InputsEvents {
  final int offerPrice;
  final String driverFirstName;
  final String driverLastName;
  final String driverPhone;
  final String driverId;
  final String driverPhoto;
  final String packageId;

  SendOffer(
      {required this.offerPrice,
      required this.driverId,
      required this.driverFirstName,
      required this.driverLastName,
      required this.driverPhone,
      required this.driverPhoto,required this.packageId});

  @override
  List<Object?> get props => [
        offerPrice,
        driverFirstName,
        driverLastName,
        driverPhone,
        driverId,
        driverPhoto,
    packageId
      ];
}
