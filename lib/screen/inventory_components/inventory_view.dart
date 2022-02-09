import 'package:flutter/material.dart';
import 'package:router_go/bloc/global/theme_bloc.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../database/model/inventory_model.dart';
import '../../screen/global_components/filter_section.dart';
import '../../utils/string_handler.dart';
import 'inventory_tile_dummy.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({
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
              if (snapshot.connectionState == ConnectionState.active)
                const FilterSectionWithBtns(
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
              FilterSectionWithBtns(
                title: '${snapshot.data!.length} items',
                btnType: 'inventory',
              ),
              Expanded(
                child: InventoryList(
                    combiner: combiner, snapshot: snapshot, theme: theme),
              ),
            ],
          );
        }
      },
    );
  }
}
