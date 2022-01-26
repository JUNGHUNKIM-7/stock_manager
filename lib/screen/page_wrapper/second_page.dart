import 'package:flutter/material.dart';
import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../inventory_components/inventory_view.dart';
import '../../screen/global_components/dark_mode_container.dart';
import '../../screen/global_components/search_field.dart';
import '../../styles.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.04,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
            child: DarkModeContainer(
              height: height * 0.00012,
              theme: theme,
              child: const SearchField(
                type: 'inventory',
                hintText: 'Inventory Field',
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
                child: InventoryView(theme: theme),
              ),
            ),
          ),
          const SizedBox(
            height: outerSpacing,
          ),
        ],
      ),
    );
  }
}
