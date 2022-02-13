import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/database/repository/gsheet_handler.dart';

class QrFloatingBtn extends StatelessWidget {
  const QrFloatingBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Make a Deal with QR',
      elevation: 10.0,
      child: const Icon(Icons.qr_code_scanner_rounded),
      onPressed: () => context.goNamed('qrCamera'),
    );
  }
}

class ExportToExcelBtn extends StatelessWidget {
  const ExportToExcelBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);
    final _handler = GSheetHandler();

    return StreamBuilder<List<History>>(
        stream: combiner.filterHisByStatus,
        builder: (context, historySnapShot) {
          if (historySnapShot.hasData) {
            return StreamBuilder<int>(
                stream: combiner.chipBloc.stream,
                builder: (context, chipSnapShot) {
                  return StreamBuilder<int>(
                      stream: combiner.yearSelection.yearStream,
                      builder: (context, yearSnapShot) {
                        return FloatingActionButton(
                          tooltip: 'Save Filtered Data',
                          child: const Icon(Icons.save),
                          onPressed: () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.yellow[600],
                                  content: const Text(
                                      'Pending: Processing Your Data'),
                                ),
                              );
                              await GSheetHandler.makeHistorySheet(
                                  SheetType.temp,
                                  chipSnapShot.data,
                                  yearSnapShot.data);
                              for (var element
                                  in (historySnapShot.data as List<History>)) {
                                await _handler.insertOne(
                                    history: History.toMap(element),
                                    type: SheetType.temp);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green[600],
                                  content: const Text(
                                      'Success: Saved Current Filtered Data to "temp" Sheet'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
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
}
