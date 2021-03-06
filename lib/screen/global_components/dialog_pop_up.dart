import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_tracker/bloc/constant/blocs_combiner.dart';
import 'package:inventory_tracker/bloc/constant/provider.dart';
import 'package:inventory_tracker/bloc/global/history_view.dart';
import 'package:inventory_tracker/database/model/inventory_model.dart';
import 'package:inventory_tracker/styles.dart';

import '../../database/model/history_model.dart';
import '../../utils/string_handler.dart';

class DialogPopUp extends StatelessWidget {
  const DialogPopUp({
    Key? key,
    required this.type,
    this.historySnapshot,
    this.bookMarkSnapShot,
    this.clean,
  }) : super(key: key);

  final AsyncSnapshot<List<Inventory>>? bookMarkSnapShot;
  final AsyncSnapshot<List<History>>? historySnapshot;
  final PanelEnum type;
  final void Function()? clean;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    switch (type) {
      case PanelEnum.history:
        return StreamBuilder(
            stream: theme.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
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
                      style: Theme.of(context).textTheme.headline3?.copyWith(
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
                      style: Theme.of(context).textTheme.headline3?.copyWith(
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
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontSize: 14,
                                    color: snapshot.data == true
                                        ? Styles.darkColor
                                        : Styles.lightColor,
                                  ),
                        ),
                        subtitle: Text(
                          '${history.date}'.substring(0, 10),
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontSize: 14,
                                    color: snapshot.data == true
                                        ? Styles.darkColor
                                        : Styles.lightColor,
                                  ),
                        ),
                        title: history.title.length > 10
                            ? Text(
                                '${history.title.substring(0, 10).toCapitalized()}...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: snapshot.data == true
                                            ? Styles.darkColor
                                            : Styles.lightColor))
                            : Text(history.title.toCapitalized(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: snapshot.data == true
                                            ? Styles.darkColor
                                            : Styles.lightColor)),
                        leading: history.status == 'y'
                            ? snapshot.data ?? false
                                ? Icon(
                                    Icons.local_shipping_outlined,
                                    color: Colors.redAccent,
                                    size: 26,
                                  )
                                : Icon(
                                    Icons.local_shipping_outlined,
                                    color: Colors.amber,
                                    size: 26,
                                  )
                            : snapshot.data ?? false
                                ? Icon(
                                    Icons.add_business,
                                    color: Colors.amber,
                                    size: 26,
                                  )
                                : Icon(
                                    Icons.add_business,
                                    color: Colors.redAccent,
                                    size: 26,
                                  ),
                        onTap: () =>
                            context.goNamed('historyDetails', extra: history),
                      );
                    }),
                  ),
                ),
              );
            });
      case PanelEnum.inventory:
        return StreamBuilder(
            stream: theme.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
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
                      children: List.generate(bookMarkSnapShot!.data!.length,
                          (int idx) {
                        final inventory =
                            bookMarkSnapShot?.data![idx] as Inventory;

                        return ListTile(
                          leading: Icon(
                            Icons.bookmark_border,
                            color: snapshot.data == true
                                ? Styles.darkColor
                                : Styles.lightColor,
                          ),
                          subtitle: inventory.memo.length > 11
                              ? Text(
                                  '${inventory.memo.substring(0, 11).toCapitalized()}...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                        fontSize: 14,
                                        color: snapshot.data == true
                                            ? Styles.darkColor
                                            : Styles.lightColor,
                                      ),
                                )
                              : Text(
                                  inventory.memo.toCapitalized(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                        fontSize: 14,
                                        color: snapshot.data == true
                                            ? Styles.darkColor
                                            : Styles.lightColor,
                                      ),
                                ),
                          title: inventory.title.length > 11
                              ? Text(
                                  '${inventory.title.substring(0, 11).toCapitalized()}...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: snapshot.data == true
                                              ? Styles.darkColor
                                              : Styles.lightColor))
                              : Text(inventory.title.toCapitalized(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: snapshot.data == true
                                              ? Styles.darkColor
                                              : Styles.lightColor)),
                          trailing: Text(
                            '${inventory.qty}',
                            style:
                                Theme.of(context).textTheme.bodyText2?.copyWith(
                                      fontSize: 14,
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
                        style: Theme.of(context).textTheme.headline3?.copyWith(
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
