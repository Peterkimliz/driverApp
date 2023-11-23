import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiri/home%20/bloc/state.dart';
import 'package:http/http.dart' as http;
import 'package:safiri/utils/constants.dart';

import '../places_search_result.dart';
import 'event.dart';

class LocationBloc extends Bloc<LocationSearchEvents, LocationSearchState> {
  var client = http.Client();

  LocationBloc() : super(InitialState()) {
    on<SearchLocationName>((event, emit) async {
      emit(Loading());
      List<PlacesSearchResult> response =
          await searchLocation(name: event.name);
      emit(LoadedState(results: response));
    });
    on<SearchClear>((event, emit) async {
      emit(LoadedState(results: []));
    });
  }

  searchLocation({required String name}) async {
    try {
      var url =
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${name}&country=ke&key=${mapKey}";
      var jsonResponse = await client.get(Uri.parse(url));

      var response = jsonDecode(jsonResponse.body);
      print("Response is $response}");
      if (response["status"] == "OK") {
        print("hello result")
;        List places = response["results"];
        List<PlacesSearchResult> foundPlaces = places.map((e) => PlacesSearchResult.fromJson(e)).toList();
        return foundPlaces;
      }

      return [];
    } catch (e) {
      print("error is ${e}");
    }
  }
}
