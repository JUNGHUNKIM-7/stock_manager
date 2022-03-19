import 'package:flutter/material.dart';
import 'package:inventory_tracker/styles.dart';

import '../../app.dart';
import '../../bloc/global/settings_bloc.dart';
import '../../database/in_app_purchase/purchase_api.dart';
import '../../utils/datetime_tz_handler.dart';
import '../../utils/restart_widget.dart';

class CredentialsTile extends StatelessWidget {
  const CredentialsTile({
    Key? key,
    required this.themeSnapshot,
    required this.settings,
  }) : super(key: key);
  final AsyncSnapshot<bool> themeSnapshot;
  final SettingsBloc settings;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: settings.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              title: Text(
                'GoogleSheet Credentials',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 16,
                    letterSpacing: 0.6,
                    color: themeSnapshot.data ?? false
                        ? Styles.lightColor
                        : Styles.darkColor),
              ),
              leading: snapshot.data!['secret'].isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.cyan,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.pink,
                    ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: themeSnapshot.data == true
                              ? Styles.darkColor
                              : Styles.lightColor,
                          title: Text(
                            'Google Credentials',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                    fontSize: 24,
                                    color: themeSnapshot.data == true
                                        ? Styles.lightColor
                                        : Styles.darkColor),
                          ),
                          content: Text(
                            'Please provide your GoogleSheet credentials',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(fontSize: 18),
                          ),
                          actions: [
                            TextField(
                              autofocus: true,
                              obscureText: true,
                              autocorrect: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeSnapshot.data == true
                                        ? Styles.lightColor
                                        : Styles.darkColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gapPadding: 20,
                                ),
                              ),
                              onChanged: (String value) {
                                settings.catchCredential(value);
                              },
                            ),
                            SizedBox(
                              height: innerSpacing,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                            fontSize: 16,
                                            color: themeSnapshot.data == true
                                                ? Styles.lightColor
                                                : Styles.darkColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox(
                                  width: innerSpacing,
                                ),
                                OutlinedButton(
                                  child: Text(
                                    'OK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                            fontSize: 16,
                                            color: themeSnapshot.data == true
                                                ? Styles.lightColor
                                                : Styles.darkColor),
                                  ),
                                  onPressed: () async {
                                    RestartWidget.restartApp(context);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ));
              },
            );
          }
          return Container();
        });
  }
}

class SheetIdTile extends StatelessWidget {
  const SheetIdTile({
    Key? key,
    required this.themeSnapshot,
    required this.settings,
  }) : super(key: key);
  final AsyncSnapshot<bool> themeSnapshot;
  final SettingsBloc settings;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: settings.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              title: Text(
                'GoogleSheet ID',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 16,
                    letterSpacing: 0.6,
                    color: themeSnapshot.data ?? false
                        ? Styles.lightColor
                        : Styles.darkColor),
              ),
              leading: snapshot.data!['sheetId'].isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.cyan,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.pink,
                    ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: themeSnapshot.data == true
                              ? Styles.darkColor
                              : Styles.lightColor,
                          title: Text(
                            'GoogleSheet ID',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                    fontSize: 24,
                                    color: themeSnapshot.data == true
                                        ? Styles.lightColor
                                        : Styles.darkColor),
                          ),
                          content: Text(
                            'Please provide your GoogleSheet ID',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(fontSize: 18),
                          ),
                          actions: [
                            TextField(
                              autofocus: true,
                              autocorrect: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeSnapshot.data == true
                                        ? Styles.lightColor
                                        : Styles.darkColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gapPadding: 20,
                                ),
                              ),
                              onChanged: (String value) {
                                settings.catchSheetId(value);
                              },
                            ),
                            SizedBox(
                              height: innerSpacing,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                            fontSize: 16,
                                            color: themeSnapshot.data == true
                                                ? Styles.lightColor
                                                : Styles.darkColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox(
                                  width: innerSpacing,
                                ),
                                OutlinedButton(
                                  child: Text(
                                    'OK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                            fontSize: 16,
                                            color: themeSnapshot.data == true
                                                ? Styles.lightColor
                                                : Styles.darkColor),
                                  ),
                                  onPressed: () async {
                                    RestartWidget.restartApp(context);
                                    await purchaseApi.getUserStatus();
                                    await RunApp.runApplication(
                                        purchaseApi.getSubStatusBloc);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ));
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          }
          return Container();
        });
  }
}

class TimeZoneTile extends StatelessWidget {
  const TimeZoneTile({
    Key? key,
    required this.themeSnapshot,
    required this.settings,
  }) : super(key: key);
  final AsyncSnapshot<bool> themeSnapshot;
  final SettingsBloc settings;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: settings.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              title: Text(
                'Select TimeZone',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 16,
                    letterSpacing: 0.6,
                    color: themeSnapshot.data ?? false
                        ? Styles.lightColor
                        : Styles.darkColor),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              leading: snapshot.data!['tz'].isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.cyan,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.pink,
                    ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          backgroundColor: themeSnapshot.data == true
                              ? Styles.darkColor
                              : Styles.lightColor,
                          title: Text(
                            'Set TimeZone',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                    fontSize: 24,
                                    color: themeSnapshot.data == true
                                        ? Styles.lightColor
                                        : Styles.darkColor),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                  DateTimeHandler.getTzList().length, (idx) {
                                final li = DateTimeHandler.getTzList();
                                return ListTile(
                                  title: Text(
                                    li[idx].replaceAll('_', ' '),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.copyWith(
                                            fontSize: 16,
                                            color: themeSnapshot.data == true
                                                ? Styles.lightColor
                                                : Styles.darkColor),
                                  ),
                                  onTap: () {
                                    settings.catchTZValue(li[idx]);
                                    Navigator.of(context).pop();
                                    RestartWidget.restartApp(context);
                                  },
                                );
                              }),
                            ),
                          ),
                          actions: [
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Close',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                        fontSize: 16,
                                        color: themeSnapshot.data == true
                                            ? Styles.lightColor
                                            : Styles.darkColor),
                              ),
                            )
                          ]);
                    });
              },
            );
          }
          return Container();
        });
  }
}

class HeaderTile extends StatelessWidget {
  const HeaderTile({
    Key? key,
    required this.themeSnapshot,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final AsyncSnapshot<bool> themeSnapshot;
  final IconData icon;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: themeSnapshot.data ?? false
          ? Icon(
              icon,
              color: Styles.lightColor,
            )
          : Icon(
              icon,
              color: Styles.darkColor,
            ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline3?.copyWith(
            fontSize: 16,
            letterSpacing: 0.6,
            color: themeSnapshot.data ?? false
                ? Styles.lightColor
                : Styles.darkColor),
      ),
      onTap: onTap,
    );
  }
}
