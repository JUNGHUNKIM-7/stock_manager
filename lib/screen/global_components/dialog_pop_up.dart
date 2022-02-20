import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/history_view.dart';
import 'package:stock_manager/database/model/inventory_model.dart';
import 'package:stock_manager/styles.dart';

import '../../database/model/history_model.dart';

class DialogPopUp extends StatelessWidget {
  const DialogPopUp({
    Key? key,
    required this.type,
    this.historySnapshot,
    this.inventorySnapshot,
    this.clean,
  }) : super(key: key);

  final AsyncSnapshot<List>? inventorySnapshot;
  final AsyncSnapshot<List<History>>? historySnapshot;
  final HistoryViewBlocEnum type;
  final void Function()? clean;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    switch (type) {
      case HistoryViewBlocEnum.history:
        return StreamBuilder(
            stream: theme.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return AlertDialog(
                backgroundColor: snapshot.data == true
                    ? Styles.lightColor
                    : Styles.darkColor,
                title: Text(
                  'Trade History',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                      fontSize: 20,
                      color: snapshot.data ?? false
                          ? Styles.darkColor
                          : Styles.lightColor),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      clean!();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Delete All',
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontSize: 16,
                          color: snapshot.data ?? false
                              ? Styles.darkColor
                              : Styles.lightColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontSize: 16,
                          color: snapshot.data ?? false
                              ? Styles.darkColor
                              : Styles.lightColor),
                    ),
                  )
                ],
                content: SingleChildScrollView(
                  child: Column(
                    children:
                        List.generate(historySnapshot!.data!.length, (int idx) {
                      final history = historySnapshot!.data![idx];

                      return ListTile(
                        trailing: Text(
                          '${history.val}',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: snapshot.data == true
                                        ? Styles.darkColor
                                        : Styles.lightColor,
                                  ),
                        ),
                        subtitle: Text(
                          '${history.date}'.substring(0, 10),
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: snapshot.data == true
                                        ? Styles.darkColor
                                        : Styles.lightColor,
                                  ),
                        ),
                        title: history.title.length > 20
                            ? Text('${history.title.substring(0, 20)}...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: snapshot.data == true
                                            ? Styles.darkColor
                                            : Styles.lightColor))
                            : Text(history.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: snapshot.data == true
                                            ? Styles.darkColor
                                            : Styles.lightColor)),
                        leading: history.status == 'y'
                            ? const Icon(Icons.arrow_circle_up_outlined,
                                color: Color(0xffD946EF), size: 30)
                            : const Icon(Icons.arrow_circle_down_outlined,
                                color: Color(0xff4ADE80), size: 30),
                        onTap: () =>
                            context.goNamed('historyDetails', extra: history),
                      );
                    }),
                  ),
                ),
              );
            });
      case HistoryViewBlocEnum.inventory:
        return StreamBuilder(
            stream: theme.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return AlertDialog(
                  backgroundColor: snapshot.data == true
                      ? Styles.lightColor
                      : Styles.darkColor,
                  title: Text(
                    'Bookmarks',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontSize: 20,
                        color: snapshot.data == true
                            ? Styles.darkColor
                            : Styles.lightColor),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                          inventorySnapshot!.data!
                              .where((element) => element.bookMark == true)
                              .length, (int idx) {
                        final inventory = inventorySnapshot?.data
                            ?.where((element) => element.bookMark == true)
                            .toList()[idx] as Inventory;

                        return ListTile(
                          leading: Icon(
                            Icons.bookmark_border,
                            color: snapshot.data == true
                                ? Styles.darkColor
                                : Styles.lightColor,
                          ),
                          subtitle: Text(
                            inventory.memo,
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: snapshot.data == true
                                          ? Styles.darkColor
                                          : Styles.lightColor,
                                    ),
                          ),
                          title: inventory.title.length > 20
                              ? Text('${inventory.title.substring(0, 20)}...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: snapshot.data == true
                                              ? Styles.darkColor
                                              : Styles.lightColor))
                              : Text(inventory.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: snapshot.data == true
                                              ? Styles.darkColor
                                              : Styles.lightColor)),
                          trailing: Text(
                            '${inventory.qty}',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: snapshot.data == true
                                          ? Styles.darkColor
                                          : Styles.lightColor,
                                    ),
                          ),
                          onTap: () =>
                              context.goNamed('historyForm', extra: inventory),
                        );
                      }),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                            fontSize: 16,
                            color: snapshot.data ?? false
                                ? Styles.darkColor
                                : Styles.lightColor),
                      ),
                    )
                  ]);
            });
      default:
        throw Exception('Unknown HistoryViewBlocEnum');
    }
  }
}
