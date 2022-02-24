import 'package:flutter/material.dart';
import 'package:qr_sheet_stock_manager/bloc/global/theme_bloc.dart';
import 'package:qr_sheet_stock_manager/bloc/history/history_bloc.dart';
import 'package:qr_sheet_stock_manager/bloc/inventory/inventory_bloc.dart';
import 'package:qr_sheet_stock_manager/database/model/history_model.dart';
import 'package:qr_sheet_stock_manager/database/repository/gsheet_handler.dart';

import '../../styles.dart';

dismissHistory(
    BuildContext context,
    SheetHandlerMain handler,
    History? history,
    HistoryBloc historyBloc,
    InventoryBloc inventoryBloc,
    ThemeBloc theme) async {
  showDialog(
    context: context,
    builder: (context) {
      return StreamBuilder<bool>(
          stream: theme.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AlertDialog(
                backgroundColor: snapshot.data ?? false
                    ? Styles.darkColor
                    : Styles.lightColor,
                title: Text(
                  'Delete?',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 24),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${history?.title}-${history?.memo}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const SizedBox(height: innerSpacing),
                    Text(
                      'Date: ${history?.date}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const SizedBox(height: innerSpacing),
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        history?.status == 'y'
                            ? snapshot.data ?? false
                                ? const Icon(
                                    Icons.local_shipping_outlined,
                                    color: Colors.redAccent,
                                  )
                                : const Icon(
                                    Icons.local_shipping_outlined,
                                    color: Colors.amber,
                                  )
                            : snapshot.data ?? false
                                ? const Icon(
                                    Icons.add_business,
                                    color: Colors.amber,
                                  )
                                : const Icon(
                                    Icons.add_business,
                                    color: Colors.redAccent,
                                  ),
                        Text(
                          ' (${history?.status == 'y' ? 'Out' : 'In'})',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    )
                  ],
                ),
                actions: [
                  OutlinedButton(
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(fontSize: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  OutlinedButton(
                    child: Text(
                      'Delete',
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(fontSize: 14),
                    ),
                    onPressed: () async {
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
                      final String nowVal = await handler.getCellVal(
                        id: history!.id,
                        type: SheetType.inventory,
                      );

                      if (history.status == 'y') {
                        try {
                          await handler
                              .deleteAndUpdateQty(
                                history: history,
                                nowVal: nowVal,
                              )
                              .whenComplete(() => Future.wait([
                                    historyBloc.reload(),
                                    inventoryBloc.reload()
                                  ]))
                              .whenComplete(() =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green[600],
                                      content: Text(
                                        'Success: Deleted Item from "history" Sheet (and Restored Qty in "inventory" Sheet)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red[600],
                              content: Text(
                                'Not Found Item in "inventory Sheet"',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(fontSize: 14),
                              ),
                            ),
                          );
                        }
                      } else {
                        try {
                          await handler
                              .deleteAndUpdateQty(
                                  history: history,
                                  nowVal: nowVal,
                                  workingType: 'subtract')
                              .whenComplete(() => Future.wait([
                                    historyBloc.reload(),
                                    inventoryBloc.reload()
                                  ]))
                              .whenComplete(() =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green[600],
                                      content: Text(
                                        'Success: Deleted Item from "history" Sheet (and Restored Qty in "inventory" Sheet)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red[600],
                            content: Text(
                              'Not Found Item in "inventory Sheet"',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(fontSize: 14),
                            ),
                          ));
                        }
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
            return Container();
          });
    },
  );
}
