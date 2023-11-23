import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_shared/config.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:safiri/packages/package_details.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../home /places_search_result.dart';
import 'bloc/package_bloc.dart';
import 'bloc/package_events.dart';
import 'bloc/package_state.dart';
import 'offer_bottom.dart';
import 'package.dart';

class PackagesView extends StatefulWidget {
  final List<PlacesSearchResult> selectedLocations;

  PackagesView({super.key, required this.selectedLocations});

  @override
  State<PackagesView> createState() => _PackagesViewState();
}

class _PackagesViewState extends State<PackagesView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  List<Package> addedPackages = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  @override
  void initState() {
    geo.Geolocator.getLastKnownPosition().then((value) async {
      if (value == null) return;
      (await _controller.future).animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(value.latitude, value.longitude), zoom: 15),
        ),
      );
    });
    super.initState();
    addCustomIcon();
  }

  @override
  Widget build(BuildContext context) {
    context.read<PackageBloc>().add(SearchPackage(
        name: false, selectedLocations: widget.selectedLocations));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: const Text("Packages"),
      ),
      body: Stack(
        children: [
          BlocConsumer<PackageBloc, PackageState>(
            builder: (context, state) {
              return GoogleMap(
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                markers: (state is LoadedState && (state.packages.isNotEmpty))
                    ? state.packages
                        .map((e) => Marker(
                            onTap: () {
                              var index = addedPackages
                                  .indexWhere((element) => element.id == e.id);
                              itemScrollController.scrollTo(
                                  index: index,
                                  duration: Duration(seconds: 2),
                                  curve: Curves.easeInOutCubic);
                            },
                            infoWindow: InfoWindow(
                              title: e.name,
                            ),
                            markerId: MarkerId(e.id!),
                            icon: markerIcon,
                            position: LatLng(
                                e.startDestination!.latlng!.latitude,
                                e.startDestination!.latlng!.longitude)))
                        .toSet()
                    : <Marker>{},
                // polylines: userController.polyline,
                myLocationEnabled: true,
                padding: const EdgeInsets.only(top: 300.0),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      fallbackLocation.latitude, fallbackLocation.longitude),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
            },
            listener: (BuildContext context, Object? state) {
              if (state is LoadedState) {
                if (addedPackages.isEmpty) {
                  setState(() {
                    addedPackages.addAll(state.packages);
                  });
                }
              }
            },
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CustomTheme.neutralColors.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.navigation_sharp,
                            color: Colors.grey,
                            size: 35,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Container(
                              height: 20,
                              width: 5,
                              color: Colors.transparent,
                            ),
                          ),
                          Icon(
                            Icons.location_on_sharp,
                            color: Colors.grey,
                            size: 35,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.selectedLocations[0].formattedAddress!),
                          const Divider(
                            thickness: 2,
                            color: Colors.red,
                          ),
                          Text(widget.selectedLocations[1].formattedAddress!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                height: 150,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                width: MediaQuery.of(context).size.width,
                child: addedPackages.isNotEmpty
                    ? ScrollablePositionedList.builder(
                        itemScrollController: itemScrollController,
                        scrollOffsetController: scrollOffsetController,
                        itemPositionsListener: itemPositionsListener,
                        scrollOffsetListener: scrollOffsetListener,
                        itemCount: addedPackages.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Package package = addedPackages.elementAt(index);
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PackageDetails(package: package)));
                            },
                            child: Container(
                              height: 150,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: package.image!.isEmpty
                                        ? Icon(
                                            Icons
                                                .photo_size_select_actual_outlined,
                                            color: Colors.grey,
                                            size: 150,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: package.image!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: CustomTheme
                                                  .neutralColors.shade300,
                                              highlightColor: CustomTheme
                                                  .neutralColors.shade100,
                                              enabled: true,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: CustomTheme
                                                        .neutralColors.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                height: 150,
                                                width: 150,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${toBeginningOfSentenceCase(package.name!)}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${toBeginningOfSentenceCase(package.description!)}",
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Posted by:${toBeginningOfSentenceCase(package.owner!.firstName!)}",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(
                        height: 0,
                        width: 0,
                      )),
          )
        ],
      ),
    );
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(20.0, 20.0)),
            "images/marker_image.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }
}


