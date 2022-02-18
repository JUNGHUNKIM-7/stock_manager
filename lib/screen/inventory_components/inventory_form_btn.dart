import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../database/model/inventory_model.dart';
import '../../database/repository/gsheet_handler.dart';

class InventorySubmit extends StatelessWidget {
  const InventorySubmit({
    Key? key,
    required this.combiner,
    required this.handler,
    required this.uuid,
  }) : super(key: key);
  final BlocsCombiner combiner;
  final GSheetHandler handler;
  final Uuid uuid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: combiner.inventoryAddFormStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        return OutlinedButton(
          onPressed: (snapshot.hasData && snapshot.data!.isNotEmpty)
              ? () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.yellow[600],
                      content: const Text('Pending: Processing Your Request'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  try {
                    await handler
                        .insertOne(
                          inventory: Inventory.toMap(
                            Inventory(
                              id: uuid.v4(),
                              title: snapshot.data?['title'] ?? '',
                              memo: snapshot.data?['memo'] ?? '',
                              qty: snapshot.data?['qty'] ?? '0',
                            ),
                          ),
                          type: SheetType.inventory,
                        )
                        .whenComplete(
                          () => combiner.inventoryBloc.reload(),
                        )
                        .whenComplete(
                          () => context.goNamed('home'),
                        );

                    combiner.titleFieldBloc
                        .clearInventoryForm(FormFields.title);
                    combiner.memoFieldBloc.clearInventoryForm(FormFields.memo);
                    combiner.qtyFieldBloc.clearInventoryForm(FormFields.qty);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green[600],
                        content:
                            const Text('Success: Added to "inventory" Sheet'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[600],
                        content: Text('Failed: ${e.toString().split(':')[1]}'),
                      ),
                    );
                  }
                }
              : null,
          child: Text(
            'Save to Inventory',
            style:
                Theme.of(context).textTheme.headline3?.copyWith(fontSize: 16),
          ),
        );
      },
    );
  }
}
