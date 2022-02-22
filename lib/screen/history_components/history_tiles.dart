import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/database/repository/gsheet_handler.dart';
import 'package:stock_manager/screen/inventory_components/inventory_tile_dummy.dart';

import '../../styles.dart';
import '../../utils/string_handler.dart';
import 'history_dismiss_func.dart';

class HistoryTiles extends StatelessWidget {
  HistoryTiles({
    Key? key,
    required this.theme,
    required this.snapshot,
  }) : super(key: key);

  final ThemeBloc theme;
  final AsyncSnapshot<List<History>> snapshot;
  final GSheetHandler handler = GSheetHandler();

  @override
  Widget build(BuildContext context) {
    final historyHistory = BlocProvider.of<BlocsCombiner>(context).historyView;
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
    final historyBloc = BlocProvider.of<BlocsCombiner>(context).historyBloc;
    final inventoryBloc = BlocProvider.of<BlocsCombiner>(context).inventoryBloc;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
          horizontal: innerSpacing, vertical: innerSpacing),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, idx) {
        final history = snapshot.data?[idx];

        return GestureDetector(
          onTap: () {
            historyHistory.push(history);
            context.goNamed('historyDetails', extra: history);
          },
          child: Dismissible(
            key: ValueKey(history?.id),
            secondaryBackground: const SecondBackGround(),
            background: const PrimaryBackGround(),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await dismissHistory(
                  context, handler, history, historyBloc, inventoryBloc, theme);
            },
            child: HistoryTile(history: history!),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey[700],
          thickness: 1.0,
        );
      },
    );
  }
}

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.comfortable,
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          history.status.toLowerCase() == 'y'
              ? Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.cyanAccent,
                  size: 26,
                )
              : Icon(
                  Icons.add_business,
                  color: Colors.limeAccent,
                  size: 26,
                ),
          Text(
            history.val.toString(),
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: history.status == 'y'
                    ? Colors.cyanAccent
                    : Colors.limeAccent),
          ),
        ],
      ),
      title: history.title.length > 10
          ? Text(
              '${history.title.substring(0, 10).toTitleCase()}...${history.title.substring(history.title.length - 3, history.title.length).toTitleCase()}',
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16),
            )
          : Text(
              history.title.toTitleCase(),
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16),
            ),
      subtitle: Row(
        children: [
          Text(
            history.date!.split(' ')[0],
            style:
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14),
          ),
          SizedBox(width: innerSpacing / 1.5),
          Text(
            history.date!.split(' ')[1].substring(0, 5),
            style:
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14),
          ),
          const SizedBox(width: innerSpacing / 4),
          Text(
            history.jm!,
            style:
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14),
          ),
        ],
      ),
      trailing: Text(
        (history.memo ?? '').length > 10
            ? '${history.memo?.substring(0, 10).toTitleCase()}...${history.memo?.substring(history.memo!.length - 3, history.memo?.length).toTitleCase()}'
            : history.memo?.toTitleCase() ?? '',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }
}
