import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/provider.dart';
import 'package:qr_sheet_stock_manager/screen/global_components/dark_mode_toggle.dart';

import '../../bloc/global/theme_bloc.dart';
import '../../database/in_app_purchase/subscription_button.dart';
import '../../styles.dart';
import 'drawer_tiles.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    final settings = BlocProvider.of<BlocsCombiner>(context).settings;

    return StreamBuilder<bool>(
        stream: theme.stream,
        builder: (context, themeSnapshot) {
          return Drawer(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SettingsHeader(themeSnapshot: themeSnapshot),
                Column(
                  children: [
                    HeaderTile(
                      themeSnapshot: themeSnapshot,
                      icon: Icons.menu_book,
                      text: 'Starting Guide',
                      onTap: () {
                        context.goNamed('manual');
                      },
                    ),
                    Divider(
                      color: Colors.grey[700],
                      thickness: 1.0,
                    ),
                    HeaderTile(
                      themeSnapshot: themeSnapshot,
                      icon: Icons.search,
                      text: 'Features',
                      onTap: () {
                        context.goNamed('features');
                      },
                    ),
                    Divider(
                      color: Colors.grey[700],
                      thickness: 1.0,
                    ),
                    TimeZoneTile(
                        themeSnapshot: themeSnapshot, settings: settings),
                    Divider(
                      color: Colors.grey[700],
                      thickness: 1.0,
                    ),
                    CredentialsTile(
                      themeSnapshot: themeSnapshot,
                      settings: settings,
                    ),
                    Divider(
                      color: Colors.grey[700],
                      thickness: 1.0,
                    ),
                    SheetIdTile(
                      themeSnapshot: themeSnapshot,
                      settings: settings,
                    ),
                    Divider(
                      color: Colors.grey[700],
                      thickness: 1.0,
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: innerSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubscriptionButton(
                        snapshot: themeSnapshot,
                      ),
                      DarkModeToggle(
                        theme: theme,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: innerSpacing,
                ),
              ],
            ),
          );
        });
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({Key? key, required this.themeSnapshot})
      : super(key: key);
  final AsyncSnapshot<bool> themeSnapshot;

  @override
  Widget build(BuildContext context) {
    final settings = BlocProvider.of<BlocsCombiner>(context).settings;
    return StreamBuilder<Map<String, dynamic>>(
        stream: settings.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current TimeZone',
                    style: themeSnapshot.data == true
                        ? Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Styles.darkColor, fontSize: 20)
                        : Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Styles.lightColor, fontSize: 20),
                  ),
                  const SizedBox(height: innerSpacing),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      (snapshot.data?['tz'] as String).replaceAll('_', ' '),
                      style: themeSnapshot.data == true
                          ? Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Styles.darkColor, fontSize: 16)
                          : Theme.of(context).textTheme.headline2?.copyWith(
                              color: Styles.lightColor, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: innerSpacing * 1.2),
                  Text(
                    'Sheet ID',
                    style: themeSnapshot.data == true
                        ? Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Styles.darkColor, fontSize: 20)
                        : Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Styles.lightColor, fontSize: 20),
                  ),
                  const SizedBox(height: innerSpacing),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      snapshot.data?['sheetId'] ?? '',
                      style: themeSnapshot.data == true
                          ? Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Styles.darkColor, fontSize: 16)
                          : Theme.of(context).textTheme.headline2?.copyWith(
                              color: Styles.lightColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
              decoration: themeSnapshot.data == true
                  ? const BoxDecoration(
                      color: Styles.lightColor,
                    )
                  : const BoxDecoration(
                      color: Styles.darkColor,
                    ),
            );
          }
          return Container();
        });
  }
}
