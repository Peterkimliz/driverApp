import 'package:client_shared/components/list_shimmer_skeleton.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../home /bloc/bloc.dart';
import '../home /bloc/event.dart';
import '../home /bloc/state.dart';
import '../home /places_search_result.dart';

showLocationBottomSheet(
    {required context,
    required Function onCloseBottom,
    required Function controllerOneChange,
    required Function controllerTwoChange,
    required Function locationTap,
    required TextEditingController textEditingControllerStart,
    required TextEditingController textEditingControllerEnd}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      )),
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => onCloseBottom(),
                child: const Icon(
                  Icons.clear_rounded,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
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
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: textEditingControllerStart,
                            onChanged: (value) {
                              controllerOneChange(value);
                            },
                            onTap: () {
                              BlocProvider.of<LocationBloc>(context)
                                  .add(SearchClear());
                            },
                            decoration: const InputDecoration(
                                hintText: "Start Location",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                          ),
                          const Divider(),
                          TextFormField(
                            controller: textEditingControllerEnd,
                            onTap: () {
                              BlocProvider.of<LocationBloc>(context)
                                  .add(SearchClear());
                            },
                            onChanged: (value) {
                              controllerTwoChange(value);
                            },
                            decoration: const InputDecoration(
                                hintText: "Destination Location",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<LocationBloc, LocationSearchState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Shimmer.fromColors(
                          baseColor: CustomTheme.neutralColors.shade300,
                          highlightColor: CustomTheme.neutralColors.shade100,
                          enabled: true,
                          child: const ListShimmerSkeleton(),
                        ),
                      );
                    }
                    if (state is LoadedState) {
                      return Container(
                        height: 400,
                        child: ListView.builder(
                            itemCount: state.results.length,
                            itemBuilder: ((context, index) {
                              PlacesSearchResult place =
                                  state.results.elementAt(index);
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () => locationTap(place),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on_sharp,
                                            color: CustomTheme
                                                .neutralColors.shade400,
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  place.name!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  place.formattedAddress!,
                                                  overflow: TextOverflow.fade,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                ),
                              );
                            })),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )
            ],
          ),
        );
      }).whenComplete(() {
    BlocProvider.of<LocationBloc>(context).add(SearchClear());
  });
}
