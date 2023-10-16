import 'package:client_shared/components/list_shimmer_skeleton.dart';
import 'package:client_shared/components/user_avatar_view.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:safiri/gen/assets.gen.dart';
import 'package:safiri/settings/map_settings.dart';

import 'package:flutter_gen/gen_l10n/messages.dart';
import 'package:shimmer/shimmer.dart';

import '../config.dart';
import '../profile/profile.graphql.dart';
import '../profile/profile_view.dart';
import 'language_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Query$GetProfile$Widget(builder: (result, {fetchMore, refetch}) {
                if (result.isLoading) {
                  return Shimmer.fromColors(
                    baseColor: CustomTheme.neutralColors.shade300,
                    highlightColor: CustomTheme.neutralColors.shade100,
                    enabled: true,
                    child: const ListShimmerSkeleton(),
                  );
                }
                final driver = result.parsedData!.driver;
                return Column(children: [
                  const SizedBox(height: 4),
                  Center(
                    child: Text("${driver.firstName} ${driver.lastName}",
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      "+${driver.mobileNumber}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                      ),
                    ),
                  ),
                  const Divider(),

                  CupertinoButton(
                    minSize: 0,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    onPressed:(){},
                    child: Row(
                      children: [
                        Icon(Icons.drive_eta_rounded,size: 20,color:CustomTheme.neutralColors.shade600),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vehicles",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${driver.carPlate} . ${driver.car?.name}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Assets.ionicons.chevronForward.svg(
                            color: CustomTheme.neutralColors.shade600, width: 20, height: 20),
                      ],
                    ),
                  ),
                ]);
              }),
              const Divider(),
              const SizedBox(height: 16),
              SettingItem(
                icon: Icons.navigation,
                title: "Navigate",
                onPressed: () {
                  showBarModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const MapSettingsPage();
                      });
                },
              ),
              const Divider(),
              const SizedBox(height: 16),

              SettingItem(
                icon: Icons.person,
                title: "Account",
                onPressed: () {
                  Navigator.pushNamed(context, 'profile');
                },
              ),
              const Divider(),
              const SizedBox(height: 16),
              SettingItem(
                icon:Icons.language,
                title: S.of(context).languageSettings,
                onPressed: () {
                  showBarModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const LanguageSettings();
                      });
                },
              ),
              const Divider(),  const SizedBox(height: 16),

              SettingItem(
                icon:Icons.settings,
                title: "App Settings",
                onPressed: () {
                  showBarModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const MapSettingsPage();
                      });
                },
              ),
              const Divider(),
              const SizedBox(height: 16),

              SettingItem(
                icon:Icons.help,
                title: "Support",
                onPressed: () {

                },
              ),
              const Divider(),
              const SizedBox(height: 16),

              // SettingItem(
              //   icon: Assets.ionicons.map,
              //   title: S.of(context).mapSettings,
              //   onPressed: () {
              //     showBarModalBottomSheet(
              //         context: context,
              //         builder: (context) {
              //           return const MapSettingsPage();
              //         });
              //   },
              // ),
              // const Divider(),
              // SettingItem(
              //   icon: Assets.ionicons.language,
              //   title: S.of(context).languageSettings,
              //   onPressed: () {
              //     showBarModalBottomSheet(
              //         context: context,
              //         builder: (context) {
              //           return const LanguageSettings();
              //         });
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onPressed;
  const SettingItem(
      {Key? key,
        required this.icon,
        required this.title,
        required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: const EdgeInsets.symmetric(vertical: 4),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon,size: 20,color:CustomTheme.neutralColors.shade600),
          // icon.svg(
          //     width: 20,
          //     height: 20,
          //     color: CustomTheme.neutralColors.shade600),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          Assets.ionicons.chevronForward.svg(
              color: CustomTheme.neutralColors.shade600, width: 15, height: 15),
        ],
      ),
    );
  }
}

