import 'package:flutter/material.dart';
import 'package:router_go/bloc/global/theme_bloc.dart';
import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/screen/global_components/filter_section.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import 'history_cards.dart';
import '../../utils/string_handler.dart';

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
      stream: combiner.filteredHistoryStreamWithStatus,
      builder: (context, AsyncSnapshot<List<History>> snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FilterSectionWithBtns(
                title: '0 Histories',
                btnType: 'history',
              ),
              Flexible(
                child: Center(
                  child: Text(
                    snapshot.error.toString().toTitleCase(),
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
              FilterSectionWithBtns(
                title: '${snapshot.data!.length} Histories',
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
        throw Exception('Err: History View ');
      },
    );
  }
}
