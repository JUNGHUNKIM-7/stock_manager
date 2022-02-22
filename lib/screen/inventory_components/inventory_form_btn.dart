import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../database/repository/gsheet_handler.dart';

class InventorySubmit extends StatelessWidget {
  const InventorySubmit({
    Key? key,
    required this.combiner,
    required this.handler,
    required this.uuid,
  }) : super(key: key);
  final BlocsCombiner combiner;
  final SheetHandlerMain handler;
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
                  try {
                    await handler
                        .updateInventorAndHistory(
                            snapshot: snapshot, uuid: uuid)
                        .whenComplete(() => Future.wait([
                              combiner.inventoryBloc.reload(),
                              combiner.historyBloc.reload(),
                            ]))
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
                        content: Text(
                          'Success: Added to "inventory" Sheet',
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
                          'Failed: ${e.toString().split(':')[1]}',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontSize: 14),
                        ),
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
