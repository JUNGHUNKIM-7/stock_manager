import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/bloc/global/form_bloc.dart';
import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';

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

    return StreamBuilder(
      stream: combiner.historyAddFormStream,
      builder:
          (context, AsyncSnapshot<Map<String, dynamic>> historyFormStream) {
        return ElevatedButton(
          onPressed:
              (historyFormStream.hasData && historyFormStream.data!.isNotEmpty)
                  ? () async {
                      try {
                        if (DateTime.now().day != 1) {
                          await _insertOne(context, combiner, historyFormStream);
                        } else if (DateTime.now().day == 1) {
                          await GSheetHandler.newMonthEvent();
                          await _insertOne(context, combiner, historyFormStream);
                        } else if (DateTime.now().month == 1) {
                          await GSheetHandler.newYearEvent();
                          await _insertOne(context, combiner, historyFormStream);
                        } else {
                          throw Exception('Something went wrong : HistoryForm');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red[600],
                            content: Text('Failed: ${e.toString()}'),
                          ),
                        );
                      }
                    }
                  : null,
          child: const Text('Save to History'),
        );
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
                          'Value MUST Less or Equal than Item Quantity')
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
        content: const Text('Success: Added To History'),
      ),
    );
  }
}
