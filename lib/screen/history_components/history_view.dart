import 'package:flutter/material.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/screen/global_components/filter_button_generator.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../utils/string_handler.dart';
import 'history_cards.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return StreamBuilder(
      stream: combiner.filterHisByStatus,
      builder: (context, AsyncSnapshot<List<History>> snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (snapshot.connectionState == ConnectionState.active)
                const FilterButtonGenerator(
                  title: '0 trades',
                  btnType: 'history',
                ),
              if (snapshot.connectionState == ConnectionState.active)
                Flexible(
                  child: Center(
                    child: Text(
                      snapshot.error.toString().toTitleCase().contains(':')
                          ? snapshot.error
                              .toString()
                              .toTitleCase()
                              .split(':')[1]
                          : snapshot.error.toString().toTitleCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          );
        } else if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterButtonGenerator(
                title: '${snapshot.data!.length} trades',
                btnType: 'history',
              ),
              Expanded(
                child: CardListView(
                  theme: theme,
                  snapshot: snapshot,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          combiner.chipBloc.dispose();
          combiner.historyBloc.dispose();
          combiner.historySearchBloc.dispose();
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        throw Exception('History View ');
      },
    );
  }
}
