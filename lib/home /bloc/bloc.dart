import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:safiri/home%20/bloc/state.dart';
import 'package:safiri/utils/constants.dart';

import 'event.dart';

class LocationBloc extends Bloc<LocationSearchEvents, LocationSearchState> {
  LocationBloc() : super(InitialState()) {
    on<SearchLocationName>((event, emit) async {
      emit(Loading());
      PlacesSearchResponse response = await searchLocation(name: event.name);
      if (response.errorMessage != null) {
        emit(ErrorState(error: response.errorMessage!));
      } else {
        emit(LoadedState(results: response.results));
      }
    });
  }

  searchLocation({required String name}) async {
    try {
      final places =
          GoogleMapsPlaces(apiKey: "AIzaSyAhhiH3PrL9td9IGJWfpK3CXnU3gtsIYHY");
      PlacesSearchResponse response = await places.searchByText(name);
      print("Seached place is ${response.results}");
      return response;
    } catch (e) {
      print("error is ${e}");
    }
  }
}