import 'package:client_shared/config.dart';
import 'package:client_shared/map_providers.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safiri/current_location_cubit.dart';
import 'package:safiri/main.graphql.dart';
import 'package:safiri/map_providers/google_map_provider.dart';
import 'package:safiri/notice_bar.dart';
import 'package:safiri/schema.gql.dart';
import 'package:safiri/unregistered_driver_messages_view.dart';
import 'package:flutter_gen/gen_l10n/messages.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../config.dart';

import '../main_bloc.dart';
import '../map_providers/open_street_map_provider.dart';
import '../order_status_card_view.dart';
import '../orders_carousel_view.dart';
import '../query_result_view.dart';

class MyHomePage extends StatelessWidget with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Refetch? refetch;

  MyHomePage({Key? key}) : super(key: key) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final mainBloc = context.read<MainBloc>();
    final locationCubit = context.read<CurrentLocationCubit>();
    return Scaffold(
        key: scaffoldKey,
        // drawer: ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child: Drawer(
        //     backgroundColor: CustomTheme.primaryColors.shade100,
        //     child: BlocBuilder<MainBloc, MainState>(
        //       builder: (context, state) {
        //         return DrawerView(
        //           driver: state.driver,
        //         );
        //       },
        //     ),
        //   ),
        // ),
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
                                if (state is StatusOnline) {
                                  refetch!();
                                }
                              }, builder: (context, state) {
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
                                                                  child: bottomSheetItems(
                                                                      title:
                                                                          "Today's Earnings",
                                                                      function:
                                                                          () {},
                                                                      subtitle:
                                                                          "Kes.200",
                                                                      context:
                                                                          context))),
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
                    ? SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: SwipeButton.expand(
                            elevationThumb: 0,
                            elevationTrack: 0,
                            borderRadius: BorderRadius.circular(0),
                            thumb: const Icon(
                              Icons.double_arrow_rounded,
                              color: Colors.white,
                            ),
                            child: const Text(
                              "Go Online",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            activeThumbColor: Colors.transparent,
                            activeTrackColor: Colors.green,
                            onSwipe: (result?.isLoading ?? false)
                                ? null
                                : () async {
                                    final fcmId = await getFcmId(context);
                                    runMutation(
                                        Variables$Mutation$UpdateDriverStatus(
                                            status: Enum$DriverStatus.Online,
                                            fcmId: fcmId));
                                  }))
                    : ((state is StatusOnline)
                        ? SizedBox(
                            height: 100,
                            width: 200,
                            child: SwipeButton.expand(
                                thumb: const Icon(
                                  Icons.double_arrow_rounded,
                                  color: Colors.white,
                                ),
                                child: const Text(
                                  "Go Offline",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
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
                                      }),
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
                  color: Color(0x2e4a5569),
                  offset: Offset(0, 3),
                  blurRadius: 10)
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
}
