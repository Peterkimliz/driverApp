import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_shared/components/back_button.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:safiri/packages/bloc/package_bloc.dart';
import 'package:safiri/packages/bloc/package_state.dart';
import 'package:safiri/packages/chat/chat.dart';
import 'package:safiri/packages/offer_bottom.dart';

import 'package:safiri/packages/package.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:shimmer/shimmer.dart';

import '../repositories/package_repository.dart';

class PackageDetails extends StatelessWidget {
  final Package package;

  PackageDetails({super.key, required this.package});

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PackageBloc, PackageState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SafiriBackButton(text: "Back"),
                    const SizedBox(height: 30),
                    Container(
                      height: 300,
                      width: double.infinity,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: package.image!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
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
                            height: 300,
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
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
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
                                  color: Colors.black, fontSize: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("${toBeginningOfSentenceCase(package.description!)}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("Kes.${package.price}",
                        style: TextStyle(
                            color: Colors.redAccent.withOpacity(0.7),
                            fontSize: 14)),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: package.drivers?.indexWhere((element) =>
                                      element.id ==
                                      FirebaseAuth.instance.currentUser!.uid) ==
                                  -1 &&
                              package.hired == null
                          ? InkWell(
                              onTap: () {
                                showModalSheet(
                                    context: context,
                                    textEditingController:
                                        textEditingController,
                                    packageId: package.id);
                              },
                              child: Container(
                                width: 200,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Text(
                                  "Give Offer",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : package.hired?.id ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? InkWell(
                                  onTap: () async {
                                    String id = await getChatId(package);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                  package: package,
                                                  chatId: id,
                                                )));
                                  },
                                  child: Container(
                                    width: 200,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Text(
                                      "Message",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<String> getChatId(Package? package) async {
    List<String> users = [];
    users.add(FirebaseAuth.instance.currentUser!.uid);
    users.add(package!.owner!.id!);
    String id = await PackageRepository().getChatIdInboxes(user: users);
    return id;
  }
}
