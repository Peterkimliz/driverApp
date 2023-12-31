import 'dart:async';

import 'package:client_shared/components/marker_new.dart';
import 'package:client_shared/map_providers.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safiri/config.dart';
import 'package:safiri/current_location_cubit.dart';

import 'package:client_shared/config.dart';
import 'package:safiri/graphql/order.fragment.graphql.dart';
import 'package:safiri/main.graphql.dart';
import 'package:safiri/schema.gql.dart';
import '../main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:maps_toolkit/maps_toolkit.dart' as map_toolkit;
import 'package:latlong2/latlong.dart';

class OpenStreetMapProvider extends StatefulWidget {
  const OpenStreetMapProvider({Key? key}) : super(key: key);

  @override
  State<OpenStreetMapProvider> createState() => _OpenStreetMapProviderState();
}

class _OpenStreetMapProviderState extends State<OpenStreetMapProvider>
    with TickerProviderStateMixin {
  late final controller = AnimatedMapController(vsync: this);

  final Stream<geo.Position> streamServerLocation =
      geo.Geolocator.getPositionStream(
          locationSettings: const geo.LocationSettings(distanceFilter: 50));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    final locationCubit = context.read<CurrentLocationCubit>();
    return FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
            maxZoom: 20,
            zoom: 12,
            interactiveFlags: InteractiveFlag.drag |
                InteractiveFlag.pinchMove |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.doubleTapZoom),
        children: [
          ValueListenableBuilder(
              valueListenable:
                  Hive.box('settings').listenable(keys: ['mapProvider']),
              builder: (context, box, child) {
                String? provider = box.get('mapProvider', defaultValue: null);
                if (provider == null && mapProvider == MapProvider.mapBox) {
                  provider = 'mapbox';
                }
                switch (provider) {
                  case 'mapbox':
                    return mapBoxTileLayer;
                  default:
                    return openStreetTileLayer;
                }
              }),
          if (mapProvider == MapProvider.openStreetMap) openStreetTileLayer,
          if (mapProvider == MapProvider.mapBox) mapBoxTileLayer,
          CurrentLocationLayer(
            followOnLocationUpdate: FollowOnLocationUpdate.once,
          ),
          BlocBuilder<MainBloc, MainState>(
              builder: (context, mainBlocState) => mainBlocState
                          is StatusOnline &&
                      mainBlocState.orders.isEmpty
                  ? BlocConsumer<CurrentLocationCubit, CurrentLocationState>(
                      listener: (context, currentLocationState) {
                        if (currentLocationState.location == null ||
                            currentLocationState.radius == null) {
                          return;
                        }
                        final northeast =
                            map_toolkit.SphericalUtil.computeOffset(
                                map_toolkit.LatLng(
                                    currentLocationState.location!.latitude,
                                    currentLocationState.location!.longitude),
                                currentLocationState.radius!,
                                45);
                        final southwest =
                            map_toolkit.SphericalUtil.computeOffset(
                                map_toolkit.LatLng(
                                    currentLocationState.location!.latitude,
                                    currentLocationState.location!.longitude),
                                currentLocationState.radius!,
                                225);
                        final bounds = LatLngBounds.fromPoints([
                          LatLng(southwest.latitude, southwest.longitude),
                          LatLng(northeast.latitude, northeast.longitude)
                        ]);
                        controller.animatedFitBounds(bounds,
                            options: const FitBoundsOptions(
                                padding: EdgeInsets.all(100)));
                      },
                      builder: (context, state) {
                        if (state.location != null && state.radius != null) {
                          return CircleLayer(circles: <CircleMarker>[
                            CircleMarker(
                                point: state.location!,
                                color: Colors.blue.withOpacity(0.3),
                                borderStrokeWidth: 2,
                                borderColor:
                                    CustomTheme.secondaryColors.shade200,
                                useRadiusInMeter: true,
                                radius: state.radius!.toDouble()),
                          ]);
                        } else {
                          return Container();
                        }
                      },
                    )
                  : Container()),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state is StatusOnline &&
                  state.orders.isNotEmpty &&
                  (state.selectedOrder?.directions?.isNotEmpty ?? false)) {
                return PolylineLayer(polylineCulling: true, polylines: [
                  Polyline(
                      points: state.selectedOrder?.directions
                              ?.map((e) => LatLng(e.lat, e.lng))
                              .toList() ??
                          [],
                      strokeWidth: 5,
                      color: CustomTheme.primaryColors)
                ]);
              }
              return const SizedBox();
            },
          ),
          BlocBuilder<MainBloc, MainState>(
              builder: (context, state) => MarkerLayer(
                  markers: state.markers
                      .map((e) => Marker(
                          point: e.position,
                          width: 240,
                          height: 63,
                          builder: (context) => MarkerNew(address: e.address)))
                      .toList())),
          BlocConsumer<MainBloc, MainState>(
            listenWhen: (previous, next) {
              if (previous is StatusOnline &&
                  next is StatusOnline &&
                  previous.selectedOrder?.id == next.selectedOrder?.id) {
                return false;
              }
              return next is StatusOnline || next is StatusInService;
            },
            listener: (context, state) {
              geo.Geolocator.checkPermission().then((value) {
                if (value == geo.LocationPermission.denied) {
                  geo.Geolocator.requestPermission();
                }
              });
              final currentLocation = locationCubit.state.location;
              if (state.markers.isNotEmpty) {
                final points = state.markers
                    .map((e) => e.position)
                    .followedBy(
                        currentLocation != null ? [currentLocation] : [])
                    .toList();
                controller.animatedFitBounds(LatLngBounds.fromPoints(points),
                    options: const FitBoundsOptions(
                        padding: EdgeInsets.only(
                            top: 130, left: 130, right: 130, bottom: 500)));
              }
              if (currentLocation == null &&
                  (state is StatusOnline || state is StatusInService)) {
                geo.Geolocator.getCurrentPosition().then(
                    (value) => onLocationUpdated(value, mainBloc, context));
              }
            },
            builder: (context, state) {
              if (state is StatusOffline) {
                return const SizedBox();
              }
              return Stack(
                children: [
                  if (state is StatusOnline)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SafeArea(
                          minimum: EdgeInsets.only(
                              bottom: state.orders.isEmpty ? 96.0 : 350,
                              right: 16.0),
                          child: FloatingActionButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              mini: true,
                              elevation: 0,
                              backgroundColor:
                                  CustomTheme.primaryColors.shade50,
                              onPressed: () {
                                final currentLocation = context
                                    .read<CurrentLocationCubit>()
                                    .state
                                    .location;

                                if (currentLocation == null) return;
                                controller.animateTo(
                                    dest: currentLocation, zoom: 16);
                              },
                              child: Icon(
                                Icons.location_searching,
                                color: CustomTheme.neutralColors.shade500,
                              ))),
                    ),
                  StreamBuilder<geo.Position>(
                      stream: streamServerLocation,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          onLocationUpdated(snapshot.data!, mainBloc, context);
                        }
                        return const SizedBox();
                      }),
                ],
              );
            },
          ),
        ]);
  }
}

void onLocationUpdated(
    geo.Position position, MainBloc bloc, BuildContext context) async {
  final httpLink = HttpLink(
    "${serverUrl}graphql",
  );
  final authLink = AuthLink(
    getToken: () async => 'Bearer ${Hive.box('user').get('jwt')}',
  );
  Link link = authLink.concat(httpLink);
  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: link,
  );
  final newLocation = LatLng(position.latitude, position.longitude);
  context.read<CurrentLocationCubit>().setCurrentLocation(newLocation);
  final res = await client.mutate(Options$Mutation$UpdateDriverLocation(
      variables: Variables$Mutation$UpdateDriverLocation(
          point: Input$PointInput(
              lat: position.latitude, lng: position.longitude))));
  final List<Fragment$AvailableOrder> availableOrders = res
      .parsedData!.updateDriversLocationNew
      .map((e) => Fragment$AvailableOrder.fromJson(e.toJson()))
      .toList();
  bloc.add(AvailableOrdersUpdated(availableOrders));
}
