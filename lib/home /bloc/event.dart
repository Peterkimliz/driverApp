import 'package:equatable/equatable.dart';

abstract class LocationSearchEvents extends Equatable {}

class SearchLocationName extends LocationSearchEvents {
  final String name;

  SearchLocationName({required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}

class SearchClear extends LocationSearchEvents {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
