import 'package:flutter/material.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';

import '../../bloc/global/theme_bloc.dart';
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
            child: ListView(
              children: <Widget>[
                Header(themeSnapshot: themeSnapshot),
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
                TimeZoneTile(themeSnapshot: themeSnapshot, settings: settings),
                Divider(
                  color: Colors.grey[700],
                  thickness: 1.0,
                ),
              ],
            ),
          );
        });
  }
}

class Header extends StatelessWidget {
  const Header({Key? key, required this.themeSnapshot}) : super(key: key);
  final AsyncSnapshot<bool> themeSnapshot;

  @override
  Widget build(BuildContext context) {
    final settings = BlocProvider.of<BlocsCombiner>(context).settings;
    return StreamBuilder<Map<String, dynamic>>(
        stream: settings.stream,
        builder: (context, snapshot) {
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
                          ?.copyWith(color: Styles.darkColor, fontSize: 22)
                      : Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(color: Styles.lightColor, fontSize: 22),
                ),
                const SizedBox(height: innerSpacing),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    snapshot.data?['tz'] ?? '',
                    style: themeSnapshot.data == true
                        ? Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Styles.darkColor, fontSize: 18)
                        : Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Styles.lightColor, fontSize: 18),
                  ),
                ),
                const SizedBox(height: innerSpacing * 1.2),
                Text(
                  'Sheet ID',
                  style: themeSnapshot.data == true
                      ? Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(color: Styles.darkColor, fontSize: 22)
                      : Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(color: Styles.lightColor, fontSize: 22),
                ),
                const SizedBox(height: innerSpacing),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    snapshot.data?['sheetId'] ?? '',
                    style: themeSnapshot.data == true
                        ? Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Styles.darkColor, fontSize: 18)
                        : Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Styles.lightColor, fontSize: 18),
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
        });
  }
}
