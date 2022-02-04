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
                      .headline2
                      ?.copyWith(fontSize: 20)),
              leading: snapshot.data!['secret'].isNotEmpty
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green[300],
                    )
                  : Icon(
                      Icons.check_circle,
                      color: Colors.red[300],
                    ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
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
              title: Text('SpreadSheet ID',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(fontSize: 20)),
              leading: snapshot.data!['sheetId'].isNotEmpty
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green[300],
                    )
                  : Icon(
                      Icons.check_circle,
                      color: Colors.red[300],
                    ),
              onTap: () {},
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
                      .headline2
                      ?.copyWith(fontSize: 20)),
              trailing: const Icon(Icons.arrow_forward_ios),
              leading: snapshot.data!['tz'].isNotEmpty
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green[300],
                    )
                  : Icon(
                      Icons.check_circle,
                      color: Colors.red[300],
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
