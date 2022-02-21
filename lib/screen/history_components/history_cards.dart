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

class CardListView extends StatelessWidget {
  const CardListView({
    Key? key,
    required this.theme,
    required this.snapshot,
  }) : super(key: key);

  final ThemeBloc theme;
  final AsyncSnapshot<List<History>> snapshot;

  @override
  Widget build(BuildContext context) {
    final historyHistory = BlocProvider.of<BlocsCombiner>(context).historyView;
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
          child: Cards(
            history: history!,
            theme: theme,
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

class Cards extends StatelessWidget {
  Cards({
    Key? key,
    required this.history,
    required this.theme,
  }) : super(key: key);

  final History history;
  final ThemeBloc theme;
  final GSheetHandler handler = GSheetHandler();

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
    final historyBloc = BlocProvider.of<BlocsCombiner>(context).historyBloc;
    final inventoryBloc = BlocProvider.of<BlocsCombiner>(context).inventoryBloc;

    return Dismissible(
      key: ValueKey(history.id),
      secondaryBackground: const SecondBackGround(),
      background: const PrimaryBackGround(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => StreamBuilder<bool>(
              stream: theme.stream,
              builder: (context, snapshot) {
                return AlertDialog(
                  backgroundColor: snapshot.data ?? false
                      ? Styles.darkColor
                      : Styles.lightColor,
                  title: Text(
                    'Delete?',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${history.title}(${history.memo})',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: innerSpacing),
                      Text(
                        'Date: ${history.date}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: innerSpacing),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          history.status == 'y'
                              ? const Icon(
                                  Icons.local_shipping_outlined,
                                  color: Colors.cyanAccent,
                                )
                              : const Icon(
                                  Icons.add_business,
                                  color: Colors.limeAccent,
                                ),
                          Text(
                            ' (${history.status == 'y' ? 'Out' : 'In'})',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      )
                    ],
                  ),
                  actions: [
                    OutlinedButton(
                      child: Text(
                        'Cancel',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(fontSize: 14),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    OutlinedButton(
                      child: Text(
                        'Delete',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(fontSize: 14),
                      ),
                      onPressed: () async {
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
                        final String nowVal = await handler.getCellVal(
                            history.id, SheetType.inventory);
                        if (history.status == 'y') {
                          try {
                            await handler
                                .updateOne(
                                    history.id,
                                    'qty',
                                    history.val + int.parse(nowVal),
                                    SheetType.inventory)
                                .whenComplete(() => handler.deleteOne(
                                    history.id, SheetType.history))
                                .whenComplete(() => Future.wait([
                                      historyBloc.reload(),
                                      inventoryBloc.reload()
                                    ]))
                                .whenComplete(() =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green[600],
                                        content: Text(
                                          'Success: Deleted Item from "history" Sheet (and Restored Qty in "inventory" Sheet)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(fontSize: 14),
                                        ),
                                      ),
                                    ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red[600],
                                content: Text(
                                  'Not Found Item in "inventory Sheet"',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(fontSize: 14),
                                ),
                              ),
                            );
                          }
                        } else {
                          try {
                            await handler
                                .updateOne(
                                    history.id,
                                    'qty',
                                    int.parse(nowVal) - history.val,
                                    SheetType.inventory)
                                .whenComplete(() => handler.deleteOne(
                                    history.id, SheetType.history))
                                .whenComplete(() => Future.wait([
                                      historyBloc.reload(),
                                      inventoryBloc.reload()
                                    ]))
                                .whenComplete(() =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green[600],
                                        content: Text(
                                          'Success: Deleted Item from "history" Sheet (and Restored Qty in "inventory" Sheet)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(fontSize: 14),
                                        ),
                                      ),
                                    ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red[600],
                              content: Text(
                                'Not Found Item in "inventory Sheet"',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(fontSize: 14),
                              ),
                            ));
                          }
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }),
        );
        return result ?? false;
      },
      child: HistoryDetailsRouteBtn(history: history, theme: theme),
    );
  }
}

class HistoryDetailsRouteBtn extends StatelessWidget {
  const HistoryDetailsRouteBtn({
    Key? key,
    required this.history,
    required this.theme,
  }) : super(key: key);

  final History history;
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: theme.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: innerSpacing,
              vertical: innerSpacing,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      history.date!.split(' ')[0],
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 14),
                    ),
                    Row(
                      children: [
                        Text(
                          history.date!.split(' ')[1].substring(0, 5),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 14),
                        ),
                        const SizedBox(width: innerSpacing / 2),
                        Text(
                          history.jm!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: innerSpacing * 1.5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      history.title.length > 10
                          ? Text(
                              '${history.title.substring(0, 10).toTitleCase()}...${history.title.substring(history.title.length - 3, history.title.length).toTitleCase()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 16),
                            )
                          : Text(
                              history.title.toTitleCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 16),
                            ),
                      Text(
                        (history.memo ?? '').length > 10
                            ? '${history.memo?.substring(0, 10).toTitleCase()}...${history.memo?.substring(history.memo!.length - 3, history.memo?.length).toTitleCase()}'
                            : history.memo?.toTitleCase() ?? '',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
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
                const SizedBox(width: innerSpacing),
                if (history.status.toLowerCase() == 'y')
                  const Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.cyanAccent,
                    size: 26,
                  )
                else
                  const Icon(
                    Icons.add_business,
                    color: Colors.limeAccent,
                    size: 26,
                  ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
