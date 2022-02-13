import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/database/model/inventory_model.dart';
import 'package:stock_manager/database/repository/gsheet_handler.dart';

class SubmitHistory extends StatelessWidget {
  const SubmitHistory({
    Key? key,
    required this.handler,
    required this.inventory,
  }) : super(key: key);

  final GSheetHandler handler;
  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return StreamBuilder<Map<String, dynamic>>(
      stream: combiner.settings.stream,
      builder: (context, AsyncSnapshot settingSnapShot) {
        if (settingSnapShot.hasData) {
          return StreamBuilder<Map<String, dynamic>>(
              stream: combiner.historyAddFormStream,
              builder: (context, historyFormStream) {
                if (settingSnapShot.data!['tz'] != null ||
                    settingSnapShot.data!['tz'].isNotEmpty) {
                  return OutlinedButton(
                    onPressed: (historyFormStream.hasData &&
                            historyFormStream.data!.isNotEmpty)
                        ? () async {
                            try {
                              if (DateTime.now().day != 1) {
                                await _insertOne(
                                    context, combiner, historyFormStream);
                              } else if (DateTime.now().day == 1) {
                                await GSheetHandler.newMonthEvent();
                                await _insertOne(
                                    context, combiner, historyFormStream);
                              } else if (DateTime.now().month == 1) {
                                await GSheetHandler.newYearEvent();
                                await _insertOne(
                                    context, combiner, historyFormStream);
                              } else {
                                throw Exception(
                                    'Something went wrong : HistoryForm');
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red[600],
                                  content: Text(
                                      'Failed: ${e.toString().split(':')[1]}'),
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text('Save to History',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(fontSize: 16)),
                  );
                }
                throw Exception('Timezone is Missing');
              });
        }
        return Container();
      },
    );
  }

  Future<void> _insertOne(
    BuildContext context,
    BlocsCombiner combiner,
    AsyncSnapshot<Map<String, dynamic>> snapshot,
  ) async {
    await handler
        .insertOne(
          history: History.toMap(
            History(
              status: snapshot.data?['status'],
              val: snapshot.data?['val'] ?? 0,
              id: inventory.id,
              title: inventory.title,
              memo: inventory.memo,
              //'y' => out
              qty: snapshot.data?['status'] == 'y'
                  ? (inventory.qty != 0 &&
                          snapshot.data?['val'] <= inventory.qty)
                      ? (inventory.qty + (-snapshot.data?['val'] as int))
                      : throw Exception(
                          'Value MUST Less or Equal than Item QTY')
                  : (snapshot.data?['val'] + inventory.qty),
            ),
          ),
          type: SheetType.history,
        )
        .whenComplete(
          () => handler.updateOne(
            inventory.id,
            'qty',
            snapshot.data?['status'] == 'y'
                ? (inventory.qty != 0 && snapshot.data?['val'] <= inventory.qty)
                    ? (inventory.qty + (-snapshot.data?['val'] as int))
                    : throw Exception(
                        'Value MUST Less or Equal than Item Quantity')
                : (snapshot.data?['val'] + inventory.qty),
            SheetType.inventory,
          ),
        )
        .whenComplete(() => Future.wait([
              combiner.historyBloc.reload(),
              combiner.inventoryBloc.reload(),
            ]))
        .whenComplete(
          () => context.goNamed('home'),
        );

    combiner.statusFieldBloc.clearHistoryForm(FormFields.status);
    combiner.valFieldBloc.clearHistoryForm(FormFields.val);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[600],
        content: const Text('Success: Added to "history" Sheet'),
      ),
    );
  }
}
