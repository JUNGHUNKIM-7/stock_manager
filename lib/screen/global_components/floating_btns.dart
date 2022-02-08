import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';

import '../../bloc/global/theme_bloc.dart';
import '../../styles.dart';

class QrFloatingBtn extends StatelessWidget {
  const QrFloatingBtn({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: theme.stream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              tooltip: 'Make a Deal with QR',
              foregroundColor:
                  snapshot.data! ? Styles.darkColor : Styles.lightColor,
              backgroundColor:
                  snapshot.data! ? Styles.lightColor : Styles.darkColor,
              elevation: 10.0,
              child: const Icon(Icons.qr_code_scanner_rounded),
              onPressed: () => context.goNamed('qrCamera'),
            );
          }
          return Container();
        });
  }
}

class ExportToExcelBtn extends StatelessWidget {
  const ExportToExcelBtn({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);
    final _handler = GSheetHandler();
    return StreamBuilder(
        stream: theme.stream,
        builder: (context, AsyncSnapshot<bool> themeSnapShot) {
          if (themeSnapShot.hasData) {
            return StreamBuilder<List<History>>(
                stream: combiner.filteredHistoryStreamWithStatus,
                builder: (context, historySnapShot) {
                  if (historySnapShot.hasData) {
                    return StreamBuilder<int>(
                        stream: combiner.chipBloc.stream,
                        builder: (context, chipSnapShot) {
                          return StreamBuilder<int>(
                              stream: combiner.yearSelection.yearStream,
                              builder: (context, yearSnapShot) {
                                return FloatingActionButton(
                                  tooltip: 'Export Current History to Excel',
                                  foregroundColor: themeSnapShot.data!
                                      ? Styles.darkColor
                                      : Styles.lightColor,
                                  backgroundColor: themeSnapShot.data!
                                      ? Styles.lightColor
                                      : Styles.darkColor,
                                  elevation: 10.0,
                                  child: const Icon(Icons.save),
                                  onPressed: () async {
                                    try {
                                      await GSheetHandler.makeHistorySheet(
                                          SheetType.temp,
                                          chipSnapShot.data,
                                          yearSnapShot.data);
                                      for (var element in (historySnapShot.data
                                          as List<History>)) {
                                        await _handler.insertOne(
                                            history: History.toMap(element),
                                            type: SheetType.temp);
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green[600],
                                          content: const Text(
                                              'Success: Check Temp File in Excel Sheet'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red[600],
                                          content: Text(e.toString()),
                                        ),
                                      );
                                    }
                                  },
                                );
                              });
                        });
                  }
                  return Container();
                });
          }
          return Container();
        });
  }
}
