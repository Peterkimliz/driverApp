import 'package:client_shared/config.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:safiri/chat/chat_view.dart';
import 'package:safiri/current_location_cubit.dart';
import 'package:safiri/earnings/earnings_view.dart';
import 'package:safiri/home%20/bloc/bloc.dart';
import 'package:safiri/packages/bloc/package_bloc.dart';
import 'package:safiri/packages/chat/chat.dart';
import 'package:safiri/profile/profile_view.dart';
import 'package:safiri/register/register_view.dart';
import 'package:safiri/repositories/package_repository.dart';
import 'package:safiri/settings/settings_page.dart';
import 'package:safiri/utils/constants.dart';

import 'announcements/announcements_view.dart';
import 'config.dart';
import 'package:flutter_gen/gen_l10n/messages.dart';

import 'home /home.dart';
import 'main_bloc.dart';
import 'trip-history/trip_history_list_view.dart';
import 'wallet/wallet_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'graphql_provider.dart';
import 'package:geolocator/geolocator.dart';

// ignore: avoid_void_async
void main() async {
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await Hive.openBox('user');
  await Hive.openBox('settings');
  await CountryCodes.init();
  final locale = CountryCodes.detailsForLocale();
  if (locale.dialCode != null) {
    defaultCountryCode = locale.dialCode!;
  }
  initOneSignal();
  runApp(const MyApp());
}

void initOneSignal() {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId(oneSignalKey);
  OneSignal.shared.promptUserForPushNotificationPermission().then((value) {});
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  oneSignalObservers() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      if (result.notification.additionalData!["screen"] == "chat"
          // && Get.find<ChatController>().isChatPage.value == false
          ) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    package: result.notification.additionalData!["type"],
                    chatId: result.notification.additionalData!["chatId"])));
      } else if (result.notification.additionalData!["screen"] == "package") {}
    });
  }

  @override
  void initState() {
    oneSignalObservers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('user').listenable(),
      builder: (context, Box box, widget) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MainBloc>(
                lazy: false, create: (context) => MainBloc()),
            BlocProvider<LocationBloc>(
                lazy: false, create: (context) => LocationBloc()),
            BlocProvider<CurrentLocationCubit>(
                lazy: false, create: (context) => CurrentLocationCubit()),
            BlocProvider<PackageBloc>(
                lazy: false,
                create: (context) =>
                    PackageBloc(packageRepository: PackageRepository()))
          ],
          child: MyGraphqlProvider(
            uri: "${serverUrl}graphql",
            subscriptionUri: "${wsUrl}graphql",
            jwt: box.get('jwt').toString(),
            child: ValueListenableBuilder<Box>(
                valueListenable:
                    Hive.box('settings').listenable(keys: ['language']),
                builder: (context, box, snapshot) {
                  return MaterialApp(
                      title: 'safiri',
                      navigatorObservers: [defaultLifecycleObserver],
                      debugShowCheckedModeBanner: false,
                      localizationsDelegates: S.localizationsDelegates,
                      supportedLocales: S.supportedLocales,
                      locale: Locale(box.get('language') ?? 'en'),
                      routes: {
                        'register': (context) => const RegisterView(),
                        'profile': (context) => const ProfileView(),
                        'trip-history': (context) =>
                            const TripHistoryListView(),
                        'announcements': (context) => const AnnouncementsView(),
                        'earnings': (context) => const EarningsView(),
                        'chat': (context) => const ChatView(),
                        'wallet': (context) => const WalletView(),
                        'settings': (context) => const SettingsPage()
                      },
                      theme: CustomTheme.theme1,
                      home: const Home());
                }),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
