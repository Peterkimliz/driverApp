import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_shared/config.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_google_maps_webservices/src/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:safiri/packages/package_details.dart';
import 'package:shimmer/shimmer.dart';
import 'package:geolocator/geolocator.dart' as geo;

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
   late Uint8List icon;
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
    iconData();

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
          BlocBuilder<PackageBloc, PackageState>(builder: (context, state) {
            return GoogleMap(
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: (state is LoadedState && (state.packages.isNotEmpty))
                  ? state.packages
                      .map((e) => Marker(
                          infoWindow: InfoWindow(
                            title: e.name,
                          ),
                          markerId: MarkerId(e.id!),
                          icon: BitmapDescriptor.fromBytes(icon),
                          position: LatLng(e.startDestination!.latlng!.latitude,
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
          }),
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.navigation_sharp,
                            color: Colors.grey,
                            size: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Dash(
                                direction: Axis.vertical,
                                length: 20,
                                dashLength: 2,
                                dashColor: Colors.grey),
                          ),
                          Icon(
                            Icons.location_on_sharp,
                            color: Colors.grey,
                            size: 25,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.selectedLocations[0]!.formattedAddress!),
                          const Divider(
                            thickness: 2,
                            color: Colors.red,
                          ),
                          Text(widget.selectedLocations[1]!.formattedAddress!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  iconData() async {
    final Uint8List? icond = await MarkersWithLabel.getBytesFromCanvasDynamic(
        iconPath: 'images/logo.png',
        plateReg: 'jhu',
        fontSize: 50.0,
        iconSize: Size(100.0, 1000.0));
    setState(() {
      icon =icond!;
    });
  }
}

class PackageContainer extends StatelessWidget {
  Package package;

  PackageContainer({super.key, required this.package});

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PackageDetails(package: package)));
      },
      child: Container(
        padding: const EdgeInsets.all(10).copyWith(top: 0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${toBeginningOfSentenceCase(package.name!)}"),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.amber,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 8,
                        child: Icon(
                          Icons.circle,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        package.startDestination!.address!,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: DottedDashedLine(
                      height: 20, width: 0, axis: Axis.vertical),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_sharp,
                      color: Colors.green,
                      size: 22,
                    ),
                    Expanded(
                      child: Text(package.endDestination!.address!,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: package.image!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: CustomTheme.neutralColors.shade300,
                      highlightColor: CustomTheme.neutralColors.shade100,
                      enabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                            color: CustomTheme.neutralColors.shade300,
                            borderRadius: BorderRadius.circular(20)),
                        height: 150,
                        width: double.infinity,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("${toBeginningOfSentenceCase(package.description!)}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kes.${package.price}",
                        style: TextStyle(
                            color: Colors.redAccent.withOpacity(0.7),
                            fontSize: 14)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                if (package.drivers?.indexWhere((element) =>
                            element.id ==
                            FirebaseAuth.instance.currentUser!.uid) ==
                        -1 &&
                    package.hired == null)
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showModalSheet(
                          context: context,
                          textEditingController: textEditingController,
                          packageId: package.id);
                    },
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Give Offer",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                if (package.drivers?.indexWhere((element) =>
                        element.id == FirebaseAuth.instance.currentUser!.uid) !=
                    -1)
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Offer Sent",
                      style: TextStyle(color: Colors.green),
                    ),
                  )
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class MarkersWithLabel {
  static Future<Uint8List?> getBytesFromCanvasDynamic(
      {required String iconPath,
      required String plateReg,
      required double fontSize,
      required Size iconSize}) async {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 240, 200, 50);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    //The label code
    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        letterSpacing: 1.0,
      ),
      text: plateReg.length > 15 ? plateReg.substring(0, 15) + '...' : plateReg,
    );

    TextPainter painter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr);
    painter.text = TextSpan(
        text:
            plateReg.length > 15 ? plateReg.substring(0, 15) + '...' : plateReg,
        style: TextStyle(
            fontSize: fontSize,
            letterSpacing: 2,
            color: Colors.black,
            fontWeight: FontWeight.w600));

    painter.layout(
      minWidth: 0,
    );
    int halfTextHeight = painter.height ~/ 2;
    double fortyPercentWidth = painter.width * 0.20;
    int textWidth = painter.width.toInt() + fortyPercentWidth.toInt();
    int textHeight = painter.height.toInt() + halfTextHeight;

    // Text box rectangle for Vehicle registration label
    Rect rect =
        Rect.fromLTWH(0, 0, textWidth.toDouble(), textHeight.toDouble());
    RRect rectRadius = RRect.fromRectAndRadius(rect, const Radius.circular(10));

    canvas.drawRRect(rectRadius, paint);
    painter.paint(
        canvas, Offset(fortyPercentWidth / 4, halfTextHeight.toDouble() / 4));

    double x = (textWidth) / 2;
    double y = textHeight.toDouble();

    Path arrow = Path()
      ..moveTo(x - 25, y)
      ..relativeLineTo(50, 0)
      ..relativeLineTo(-25, 25)
      ..close();
    canvas.drawPath(arrow, paint);

    // Load the icon from the path as a list of bytes
    final ByteData dataStart = await rootBundle.load(iconPath);
    ui.Codec codec = await ui.instantiateImageCodec(
        dataStart.buffer.asUint8List(),
        targetWidth: iconSize.width.toInt());
    ui.FrameInfo fi = await codec.getNextFrame();

    Uint8List dataEnd =
        ((await fi.image.toByteData(format: ui.ImageByteFormat.png)) ??
                ByteData(0))
            .buffer
            .asUint8List();

    ui.Image image = await _loadImage(Uint8List.view(dataEnd.buffer));
    canvas.drawImage(image, Offset(x - (image.width / 2), y + 25), Paint());

    ui.Picture p = pictureRecorder.endRecording();
    ByteData? pngBytes = await (await p.toImage(
      textWidth < image.width ? image.width : textWidth,
      textHeight + image.height + 25,
    ))
        .toByteData(format: ui.ImageByteFormat.png);

    return pngBytes?.buffer.asUint8List();
  }

  static Future<ui.Image> _loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}
