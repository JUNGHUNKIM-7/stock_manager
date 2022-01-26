import 'package:flutter/material.dart';
import 'package:router_go/screen/global_components/years_picker.dart';
import '../../screen/history_components/history_chips.dart';
import '../../screen/history_components/history_view.dart';
import '../../screen/global_components/dark_mode_container.dart';
import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../global_components/search_field.dart';
import '../../styles.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

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
            child: Row(
              children: [
                Expanded(
                  child: DarkModeContainer(
                    theme: theme,
                    height: height * 0.00012,
                    child: const SearchField(
                      type: 'history',
                      hintText: 'Get History By Your Item!',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                DarkModeContainer(
                  theme: theme,
                  height: height * 0.00012,
                  child: Years(theme: theme),
                )
              ],
            ),
          ),
          const SizedBox(
            height: outerSpacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
            child: DarkModeContainer(
              theme: theme,
              height: height * 0.0001,
              child: const Chips(),
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
                child: HistoryView(theme: theme),
              ),
            ),
          ),
          const SizedBox(
            height: outerSpacing,
          )
        ],
      ),
    );
  }
}
