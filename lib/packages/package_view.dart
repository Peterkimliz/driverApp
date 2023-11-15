import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:safiri/packages/package_details.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/package_bloc.dart';
import 'bloc/package_events.dart';
import 'bloc/package_state.dart';
import 'offer_bottom.dart';
import 'package.dart';

class PackagesView extends StatelessWidget {
  const PackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PackageBloc>().add(SearchPackage(name: "active"));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<PackageBloc, PackageState>(builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is LoadedState) {
          if (state.packages.isEmpty) {
            return const Text("Hello");
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.packages.length,
                itemBuilder: (context, index) {
                  Package package = state.packages.elementAt(index);
                  return PackageContainer(package: package);
                });
          }
        }
        return Container();
      }),
    );
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

                  // DecorationImage(
                  //     fit: BoxFit.cover,
                  //     image: NetworkImage(package.image!))
                  //,
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
                    // InkWell(
                    //   onTap: () {},
                    //   child: Text(
                    //     "InProgress",
                    //     style: TextStyle(color: Colors.amber, fontSize: 14),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    showModalSheet(
                        context: context,
                        textEditingController: textEditingController);
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Give Offer",
                      style: TextStyle(color: Colors.green),
                    ),
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
