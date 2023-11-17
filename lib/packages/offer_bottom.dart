import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiri/packages/bloc/package_events.dart';

import '../profile/profile.graphql.dart';
import 'bloc/package_bloc.dart';

showModalSheet(
    {required context,
    required TextEditingController textEditingController,
    required packageId}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      context: context,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text("Offer Price"),
                TextFormField(
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Query$GetProfile$Widget(
                      builder: (result, {fetchMore, refetch}) {
                    final driver = result.parsedData!.driver;
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (textEditingController.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text(
                                      "Ensure you enter your offer price"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Okay"))
                                  ],
                                );
                              });
                        } else {
                          Navigator.pop(context);
                          BlocProvider.of<PackageBloc>(context).add(
                            SendOffer(
                              packageId: packageId,
                              offerPrice: int.parse(textEditingController.text),
                              driverId: FirebaseAuth.instance.currentUser!.uid,
                              driverFirstName: driver.firstName!,
                              driverLastName: driver.lastName!,
                              driverPhone: driver.mobileNumber,
                              driverPhoto: driver.media!.address,
                              carName: driver.car!.name,
                              carPlate: driver.carPlate!,
                            ),
                          );
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text("Send",
                              style: TextStyle(color: Colors.white))),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      });
}
