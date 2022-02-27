import 'package:flutter/material.dart';
import 'package:qr_sheet_stock_manager/bloc/global/theme_bloc.dart';
import 'package:qr_sheet_stock_manager/styles.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../database/model/inventory_model.dart';
import '../../screen/global_components/filter_button_generator.dart';
import '../../utils/string_handler.dart';
import 'inventory_tile_dummy.dart';

class InventoryListView extends StatelessWidget {
  const InventoryListView({
    Key? key,
    this.theme,
  }) : super(key: key);

  final ThemeBloc? theme;

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return StreamBuilder(
      stream: combiner.filterInventoryStream,
      builder: (context, AsyncSnapshot<List<Inventory>> snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: outerSpacing),
              if (snapshot.connectionState == ConnectionState.active)
                const FilterButtonGenerator(
                  title: '0 Items',
                  btnType: 'inventory',
                ),
              if (snapshot.connectionState == ConnectionState.active)
                Flexible(
                  child: Center(
                    child: Text(
                      snapshot.error.toString().toTitleCase(),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
            ],
          );
        } else if (snapshot.hasError) {
          combiner.inventorySearchBloc.dispose();
          combiner.inventoryBloc.dispose();
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterButtonGenerator(
                title: '${snapshot.data!.length} items',
                btnType: 'inventory',
              ),
              Expanded(
                child: InventoryTiles(
                  combiner: combiner,
                  snapshot: snapshot,
                  theme: theme,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
