import 'dart:async';
import 'package:client_shared/components/list_shimmer_skeleton.dart';
import 'package:client_shared/config.dart';
import 'package:client_shared/map_providers.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safiri/current_location_cubit.dart';
import 'package:safiri/home%20/places_search_result.dart';
import 'package:safiri/main.graphql.dart';
import 'package:safiri/map_providers/google_map_provider.dart';
import 'package:safiri/notice_bar.dart';
import 'package:safiri/packages/package_view.dart';
import 'package:safiri/schema.gql.dart';
import 'package:safiri/unregistered_driver_messages_view.dart';
import 'package:flutter_gen/gen_l10n/messages.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../config.dart';

import '../main_bloc.dart';
import '../map_providers/open_street_map_provider.dart';
import '../order_status_card_view.dart';
import '../orders_carousel_view.dart';
import '../query_result_view.dart';
import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Refetch? refetch;

  int key = 0;
  PlacesSearchResult? startLocation = null;
  PlacesSearchResult? endLocation = null;
  TextEditingController textEditingControllerStart = TextEditingController();
  TextEditingController textEditingControllerEnd = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final mainBloc = context.read<MainBloc>();
    final locationCubit = context.read<CurrentLocationCubit>();
    return Scaffold(
        key: scaffoldKey,
        body: ValueListenableBuilder(
            valueListenable: Hive.box('user').listenable(),
            builder: (context, Box box, widget) {
              if (box.get('jwt') == null) {
                return UnregisteredDriverMessagesView(
                  driver: null,
                  refetch: refetch,
                );
              }
              return LifecycleWrapper(
                  onLifecycleEvent: (event) {
                    print("emitted event is ${event}");
                    if (event == LifecycleEvent.active) {
                      refetch?.call();
                      updateNotificationId(context);
                    }
                  },
                  child: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        return Query$Me$Widget(
                            options: Options$Query$Me(
                                variables: Variables$Query$Me(
                                    versionCode: int.parse(
                                        snapshot.data?.buildNumber ??
                                            "999999")),
                                onComplete: (result, parsedData) {
                                  if (parsedData?.requireUpdate ==
                                      Enum$VersionStatus.MandatoryUpdate) {
                                    mainBloc.add(VersionStatusEvent(
                                        parsedData!.requireUpdate));
                                  } else {
                                    if (parsedData?.driver != null) {
                                      mainBloc.add(
                                          DriverUpdated(parsedData!.driver));
                                      locationCubit.setRadius(
                                          parsedData.driver.searchDistance);
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                title: const Text("Driver"),
                                                content: const Text(
                                                    "Driver information not found, Do you want to logout and login again?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        box.delete('jwt');
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Yes")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("No"))
                                                ]);
                                          });
                                    }
                                  }
                                }),
                            builder: (result, {refetch, fetchMore}) {
                              if (result.isLoading || result.hasException) {
                                return QueryResultView(result,
                                    refetch: refetch);
                              }
                              this.refetch = refetch;
                              return BlocConsumer<MainBloc, MainState>(
                                  listenWhen:
                                      (MainState previous, MainState next) {
                                if (previous is StatusUnregistered &&
                                    next is StatusUnregistered &&
                                    previous.driver?.status ==
                                        next.driver?.status) {
                                  return false;
                                }
                                if ((previous is StatusOnline) &&
                                    next is StatusOnline) {
                                  return false;
                                }
                                return true;
                              }, listener: (context, state) {
                                print("State of app is ${state}");
                                if (state is StatusOnline) {
                                  refetch!();
                                }
                              }, builder: (context, state) {
                                print("State of app is ${state}");
                                if (state is StatusUnregistered) {
                                  return UnregisteredDriverMessagesView(
                                      driver: state.driver, refetch: refetch);
                                }
                                return Stack(children: [
                                  ValueListenableBuilder(
                                      valueListenable: Hive.box('settings')
                                          .listenable(keys: ['mapProvider']),
                                      builder: (context, Box box, widget) =>
                                          getMapProvider(box)),
                                  SafeArea(
                                    minimum: const EdgeInsets.all(16),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _getMenuButton(
                                              iconData: Icons.search,
                                              onPressed: () {}),
                                          const Spacer(),
                                          if (state is! StatusInService &&
                                              state is StatusOnline)
                                            _getOnlineOfflineButton(
                                                context, state),
                                          const Spacer(),
                                          _getMenuButton(
                                              iconData: Icons.add_moderator,
                                              onPressed: () {})
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (state is StatusOffline ||
                                      (state is StatusOnline &&
                                          state.orders.isEmpty))
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: NoticeBar(
                                          title: state is StatusOffline
                                              ? S
                                                  .of(context)
                                                  .status_offline_description
                                              : S
                                                  .of(context)
                                                  .status_online_description),
                                    ),
                                  if (state is StatusOnline)
                                    Positioned(
                                      bottom: 0,
                                      child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 400,
                                          child: OrdersCarouselView()),
                                    ),
                                  if (state is StatusInService &&
                                      state.driver!.currentOrders.isNotEmpty)
                                    Positioned(
                                      bottom: 0,
                                      child: Subscription$OrderUpdated$Widget(
                                          onSubscriptionResult:
                                              (subscriptionResult, client) {
                                        if (subscriptionResult.data != null) {
                                          // TODO: Try emitting the same value as current order updated fragment.
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            refetch!();
                                          });
                                        }
                                      }, builder: (result) {
                                        return SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: OrderStatusCardView(
                                                order: state.driver!
                                                    .currentOrders.first));
                                      }),
                                    ),
                                  SizedBox.expand(
                                    child: DraggableScrollableSheet(
                                        initialChildSize: 0.3,
                                        minChildSize: 0.2,
                                        maxChildSize: 0.4,
                                        expand: false,
                                        snap: false,
                                        builder: (BuildContext context,
                                            ScrollController scrollController) {
                                          return ListView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            controller: scrollController,
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.35,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight: Radius.circular(
                                                          state is! StatusInService &&
                                                                  state
                                                                      is StatusOffline
                                                              ? 0
                                                              : 30),
                                                      topLeft: Radius.circular(
                                                          state is! StatusInService &&
                                                                  state
                                                                      is StatusOffline
                                                              ? 0
                                                              : 30),
                                                    )),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (state
                                                            is! StatusInService &&
                                                        state is StatusOffline)
                                                      _getOnlineOfflineButton(
                                                          context, state),
                                                    if (state
                                                            is! StatusInService &&
                                                        state is StatusOnline)
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Center(
                                                              child: Container(
                                                            height: 5,
                                                            width: 80,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                          )),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 7),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.25,
                                                                  child: Column(
                                                                    children: [
                                                                      bottomSheetItems(
                                                                          title:
                                                                              "Today's Earnings",
                                                                          function:
                                                                              () {},
                                                                          subtitle:
                                                                              "Kes.200",
                                                                          context:
                                                                              context),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      StreamBuilder(
                                                                          stream: FirebaseFirestore
                                                                              .instance
                                                                              .collection("packages")
                                                                              .where("hired", isEqualTo: false)
                                                                              .snapshots(),
                                                                          builder: (context, AsyncSnapshot snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              return locatinBottomSheet(context: context, count: snapshot.data!.docs.length);
                                                                            } else {
                                                                              return locatinBottomSheet(context: context, count: 0);
                                                                              ;
                                                                            }
                                                                          })
                                                                    ],
                                                                  ))),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              bottomSheetItems(
                                                                  title:
                                                                      "Driver score",
                                                                  function:
                                                                      () {},
                                                                  subtitle:
                                                                      "100%",
                                                                  context:
                                                                      context),
                                                              const SizedBox(
                                                                  height: 5),
                                                              bottomSheetItems(
                                                                  title:
                                                                      "Acceptance Rate",
                                                                  function:
                                                                      () {},
                                                                  subtitle:
                                                                      "100%",
                                                                  context:
                                                                      context)
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  )
                                ]);
                              });
                            });
                      }));
            }));
  }

  Widget getMapProvider(Box box) {
    final String? provider = box.get('mapProvider', defaultValue: null);
    if (provider == null) {
      switch (mapProvider) {
        case MapProvider.googleMap:
          return GoogleMapProvider();
        default:
          return const OpenStreetMapProvider();
      }
    }
    switch (provider) {
      case 'googlemap':
        return GoogleMapProvider();
      default:
        return const OpenStreetMapProvider();
    }
  }

  Widget _getOnlineOfflineButton(BuildContext context, MainState state) {
    final mainBloc = context.read<MainBloc>();
    return Mutation$UpdateDriverStatus$Widget(
        options: WidgetOptions$Mutation$UpdateDriverStatus(
          onCompleted: (result, parsedData) {
            if (parsedData?.updateOneDriver == null) return;

            mainBloc.add(DriverUpdated(parsedData!.updateOneDriver));
          },
          onError: (error) => showOperationErrorMessage(context, error),
        ),
        builder: (runMutation, result) {
          return Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(0, 3),
                  blurRadius: 15)
            ]),
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: (state is StatusOffline)
                    ? Container(
                        color: Colors.green,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.only(right: 180),
                          child: SwipeButton(
                            trackPadding: const EdgeInsets.all(0),
                            elevationThumb: 0,
                            thumb: const Icon(
                              Icons.double_arrow_rounded,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(0),
                            activeTrackColor: Colors.green,
                            activeThumbColor: Colors.green,
                            onSwipe: (result?.isLoading ?? false)
                                ? null
                                : () async {
                                    final fcmId = await getFcmId(context);
                                    print("token is ${fcmId}");
                                    runMutation(
                                        Variables$Mutation$UpdateDriverStatus(
                                            status: Enum$DriverStatus.Online,
                                            fcmId: fcmId));
                                  },
                            child: const Text(
                              "Go Online",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ))
                    : ((state is StatusOnline)
                        ? SizedBox(
                            height: 100,
                            width: 200,
                            child: SwipeButton.expand(
                                thumb: const Icon(
                                  Icons.double_arrow_rounded,
                                  color: Colors.white,
                                ),
                                activeThumbColor: Colors.transparent,
                                activeTrackColor: Colors.orange,
                                onSwipe: (result?.isLoading ?? false)
                                    ? null
                                    : () {
                                        runMutation(
                                            Variables$Mutation$UpdateDriverStatus(
                                                status:
                                                    Enum$DriverStatus.Offline));
                                      },
                                child: const Text(
                                  "Go Offline",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          )
                        : const SizedBox())),
          );
        });
  }

  Widget _getMenuButton(
      {required IconData iconData, required Function() onPressed}) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0x14000000), offset: Offset(3, 3), blurRadius: 25)
      ]),
      child: FloatingActionButton(
          heroTag: 'fabMenu',
          elevation: 0,
          mini: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: onPressed,
          backgroundColor: Colors.white,
          child: Icon(
            iconData,
            color: Colors.black,
          )),
    );
  }

  Widget bottomSheetItems(
      {required title,
      required Function() function,
      required subtitle,
      required context}) {
    return InkWell(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x2e4a5569), offset: Offset(0, 3), blurRadius: 5)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 17, color: Colors.grey),
                ),
                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.grey,
                  size: 15,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWalletButton(BuildContext context, MainState state) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0x14000000), offset: Offset(0, 3), blurRadius: 15)
      ]),
      child: FloatingActionButton.extended(
          heroTag: 'fabIncome',
          onPressed: () => Navigator.pushNamed(context, 'earnings'),
          backgroundColor: CustomTheme.primaryColors.shade50,
          foregroundColor: CustomTheme.primaryColors,
          icon: const Icon(Ionicons.wallet),
          elevation: 0,
          label: Text(
              (state.driver?.wallets.length ?? 0) > 0
                  ? NumberFormat.simpleCurrency(
                          name: state.driver!.wallets.first.currency)
                      .format(state.driver!.wallets.first.balance)
                  : "-",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: CustomTheme.primaryColors))),
    );
  }

  Future<String?> getFcmId(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title:
                    Text(S.of(context).message_notification_permission_title),
                content: Text(S
                    .of(context)
                    .message_notification_permission_denined_message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(S.of(context).action_ok),
                  )
                ],
              ));
      return null;
    } else {
      messaging.onTokenRefresh.listen((event) {
        updateNotificationId(context);
      });
      return messaging.getToken(
        vapidKey: "",
      );
    }
  }

  void updateNotificationId(BuildContext context) async {
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
    final fcmId = await getFcmId(context);
    await client.mutate(Options$Mutation$UpdateDriverFCMId(
        variables: Variables$Mutation$UpdateDriverFCMId(fcmId: fcmId)));
  }

  Enum$GeoProvider getMapProviders() {
    var settings = Hive.box('settings').get('mapProvider');
    print("settings are $settings");
    var provder = mapProvider;
    if (settings == 'googlemap') {
      provder = MapProvider.googleMap;
    } else if (settings == 'mapbox') {
      provder = MapProvider.mapBox;
    } else if (settings == 'openstreet') {
      provder = MapProvider.openStreetMap;
    }
    print(
        "map provider is ${provder == MapProvider.googleMap ? Enum$GeoProvider.GOOGLE : (provder == MapProvider.mapBox ? Enum$GeoProvider.MAPBOX : Enum$GeoProvider.NOMINATIM)}");
    return provder == MapProvider.googleMap
        ? Enum$GeoProvider.GOOGLE
        : (provder == MapProvider.mapBox
            ? Enum$GeoProvider.MAPBOX
            : Enum$GeoProvider.NOMINATIM);
  }

  Widget locatinBottomSheet({required BuildContext context, required count}) {
    return bottomSheetItems(
        title: "Packages",
        function: () {
          showLocationBottomSheet(context: context);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => PackagesView()));
        },
        subtitle: "${count}",
        context: context);
  }

  locationTap({required place}) {
    if (key == 0) {
      textEditingControllerStart.text = place.formattedAddress!;
      setState(() {
        startLocation = place;
      });
    } else {
      textEditingControllerEnd.text = place.formattedAddress!;
      setState(() {
        endLocation = place;
      });
    }
    if (startLocation != null && endLocation != null) {
      Navigator.pop(context);
      navigateToView(
          context: context,
          startLocation: startLocation,
          endLocation: endLocation);
      textEditingControllerStart.clear();
      textEditingControllerEnd.clear();
      Timer(const Duration(milliseconds: 4000), () {
        startLocation = null;
        endLocation = null;
      });
    }
  }

  showLocationBottomSheet({required context}) {
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
            padding:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    textEditingControllerStart.clear();
                    textEditingControllerEnd.clear();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 3.0, left: 10, bottom: 5),
                    child: Icon(
                      Icons.clear_rounded,
                      color: Colors.black,
                      size: 35,
                    ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.navigation_sharp,
                            color: Colors.grey,
                            size: 35,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              height: 20,
                              width: 5,
                              color: Colors.transparent,
                            ),
                          ),
                          const Icon(
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
                                if (value.trim().length >= 3) {
                                  setState(() {
                                    key = 0;
                                  });
                                  BlocProvider.of<LocationBloc>(context)
                                      .add(SearchLocationName(name: value));
                                }
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
                                if (value.trim().length >= 3) {
                                  setState(() {
                                    key = 1;
                                  });
                                  BlocProvider.of<LocationBloc>(context)
                                      .add(SearchLocationName(name: value));
                                }
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
                                  onTap: () => locationTap(place: place),
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
    }).whenComplete(() {
      BlocProvider.of<LocationBloc>(context).add(SearchClear());
    });
  }

  navigateToView(
      {required BuildContext context,
      PlacesSearchResult? startLocation,
      PlacesSearchResult? endLocation}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PackagesView(
                  selectedLocations: [startLocation!, endLocation!],
                  editFunction: () {
                    showLocationBottomSheet(
                        context: scaffoldKey.currentContext);
                    textEditingControllerStart.text =
                        startLocation.formattedAddress!;
                    textEditingControllerEnd.text =
                        endLocation.formattedAddress!;
                  },
                )));
  }
}
