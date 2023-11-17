import 'package:equatable/equatable.dart';

import '../package.dart';

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
  final String carName;
  final String carPlate;

  SendOffer(
      {required this.offerPrice,
      required this.driverId,
      required this.driverFirstName,
      required this.driverLastName,
      required this.driverPhone,
      required this.driverPhoto,
      required this.packageId,
      required this.carName,
      required this.carPlate});

  @override
  List<Object?> get props => [
        offerPrice,
        driverFirstName,
        driverLastName,
        driverPhone,
        driverId,
        driverPhoto,
        packageId,
        carName,
        carPlate
      ];
}

class SendMessage extends InputsEvents {
  final String message;
  final String id;
  final Package package;

  SendMessage({required this.message, required this.package, required this.id});

  @override
  List<Object?> get props => [message, package, id];
}
