import 'package:equatable/equatable.dart';
import 'package:flutter_google_maps_webservices/places.dart';

abstract class LocationSearchState extends Equatable {}

class InitialState extends LocationSearchState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loading extends LocationSearchState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadedState extends LocationSearchState {
  final List<PlacesSearchResult> results;

  LoadedState({required this.results});

  @override
  // TODO: implement props
  List<Object?> get props => [results];
}

class ErrorState extends LocationSearchState {
  final String error;

  ErrorState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
