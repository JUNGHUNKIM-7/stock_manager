import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';
import 'package:uuid/uuid.dart';

class FormBtns extends StatelessWidget {
  const FormBtns({
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
      stream: combiner.formStreams,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        return ElevatedButton(
          onPressed: (snapshot.hasData && snapshot.data!.isNotEmpty)
              ? () async {
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

                    combiner.titleField.clear();
                    combiner.memoField.clear();
                    combiner.qtyField.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product Added to your Inventory'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed : ${e.toString()}'),
                      ),
                    );
                  }
                }
              : null,
          child: const Text('ADD TO INVENTORY'),
        );
      },
    );
  }
}
