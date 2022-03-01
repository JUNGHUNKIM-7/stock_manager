import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/provider.dart';
import 'package:qr_sheet_stock_manager/database/model/history_model.dart';
import 'package:qr_sheet_stock_manager/database/utils/gsheet_handler.dart';

class QrCamera extends StatelessWidget {
  const QrCamera({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Make a Deal with QR',
      elevation: 10.0,
      child: const Icon(Icons.camera_alt_rounded),
      onPressed: () => context.goNamed('qrCamera'),
    );
  }
}

class ExportToTemp extends StatelessWidget {
  ExportToTemp({
    Key? key,
  }) : super(key: key);

  final handler = SheetHandlerMain();

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

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
                          child: const Icon(Icons.document_scanner),
                          onPressed: () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.yellow[600],
                                  content: Text(
                                    'Pending: Processing Your Request',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(fontSize: 14),
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );

                              await handler.saveHistoryStreamToTempFile(
                                  chipSnapShot: chipSnapShot,
                                  yearSnapShot: yearSnapShot,
                                  historySnapShot: historySnapShot);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green[600],
                                  content: Text(
                                    'Success: Saved Current Filtered Data to "temp" Sheet',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(fontSize: 14),
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red[600],
                                  content: Text(
                                    e.toString().split(':')[1],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(fontSize: 14),
                                  ),
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
