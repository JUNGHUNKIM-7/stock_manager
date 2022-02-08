import 'package:flutter/material.dart';

import '../../bloc/global/settings_bloc.dart';
import '../../utils/datetime_tz_handler.dart';

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
              title: Text('GoogleSheet Credentials',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 18, letterSpacing: 0.6)),
              leading: snapshot.data!['secret'].isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.redAccent,
                    ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            'Google Credentials',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(fontSize: 24),
                          ),
                          content: Column(
                            children: [
                              Text(
                                'Please provide your GoogleSheet credentials.\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(fontSize: 20),
                              ),
                              Text(
                                'If you don\'t have a GoogleSheet account,\nyou '
                                'can create one here: \n\n'
                                'https://console.developers.google.com',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(fontSize: 16),
                              )
                            ],
                          ),
                          actions: [
                            TextField(
                              autofocus: true,
                              obscureText: true,
                              autocorrect: false,
                              onChanged: (String value) {
                                settings.catchCredential(value);
                              },
                            ),
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
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
              title: Text('GoogleSheet ID',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 18, letterSpacing: 0.6)),
              leading: snapshot.data!['sheetId'].isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.redAccent,
                    ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            'GoogleSheet ID',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(fontSize: 24),
                          ),
                          content: Column(
                            children: [
                              Text(
                                'Please provide your GoogleSheet ID.\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(fontSize: 20),
                              ),
                              Text(
                                'Example: https://docs.google.com/spreadsheets/d/"YOUR SHEET ID"/edit#gid=xxx',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(fontSize: 14),
                              )
                            ],
                          ),
                          actions: [
                            TextField(
                              autofocus: true,
                              autocorrect: false,
                              onChanged: (String value) {
                                settings.catchSheetId(value);
                              },
                            ),
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
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
              title: Text('Select TimeZone',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 18, letterSpacing: 0.6)),
              trailing: const Icon(Icons.arrow_forward_ios),
              leading: snapshot.data!['tz'].isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.redAccent,
                    ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: themeSnapshot.data == true
                            ? Colors.grey
                            : Colors.white.withOpacity(0.9),
                        title: Text('Set TimeZone',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(fontSize: 24)),
                        content: Text(
                          'Please select your timezone',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        scrollable: true,
                        actions:
                            List.generate(TzHandler.countries.length, (idx) {
                          final li = TzHandler.countries;

                          return ListTile(
                            title: Text(li[idx]),
                            onTap: () {
                              settings.catchTZValue(li[idx]);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          );
                        }),
                      );
                    });
              },
            );
          }
          return Container();
        });
  }
}
