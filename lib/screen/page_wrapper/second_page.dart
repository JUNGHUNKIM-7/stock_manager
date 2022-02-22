import 'package:flutter/material.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../screen/global_components/dark_mode_container.dart';
import '../../screen/global_components/search_field.dart';
import '../../styles.dart';
import '../inventory_components/inventory_list_view.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: outerSpacing,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
          child: DarkModeContainer(
            height: height * 0.0001,
            theme: theme,
            child: const SearchField(
              type: 'inventory',
              hintText: 'Get Inventory By Item',
            ),
          ),
        ),
        const SizedBox(
          height: outerSpacing,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
            child: DarkModeContainer(
              theme: theme,
              height: 0,
              child: InventoryListView(theme: theme),
            ),
          ),
        ),
        const SizedBox(
          height: outerSpacing,
        ),
      ],
    );
  }
}
