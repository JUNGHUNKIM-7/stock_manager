import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/history_view.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/database/model/inventory_model.dart';
import 'package:stock_manager/styles.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({
    Key? key,
    this.historyViewBlocEnum,
  }) : super(key: key);
  final HistoryViewBlocEnum? historyViewBlocEnum;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
    if (historyViewBlocEnum == HistoryViewBlocEnum.history) {
      final historyHistory =
          BlocProvider.of<BlocsCombiner>(context).historyView;
      return StreamBuilder(
          stream: historyHistory.historyStream,
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return HistoryDialog(
                  theme: theme,
                  historySnapshot: snapshot,
                );
              }
            }
            return Container();
          });
    } else if (historyViewBlocEnum == HistoryViewBlocEnum.inventory) {
      final inventoryHistory =
          BlocProvider.of<BlocsCombiner>(context).inventoryBloc;
      return StreamBuilder(
          stream: inventoryHistory.stream,
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return HistoryDialog(
                  theme: theme,
                  inventorySnapshot: snapshot,
                );
              }
            }
            return Container();
          });
    } else {
      return Container();
    }
  }
}

class HistoryDialog extends StatelessWidget {
  const HistoryDialog(
      {Key? key,
      this.historySnapshot,
      this.inventorySnapshot,
      required this.theme})
      : super(key: key);

  final AsyncSnapshot<List>? historySnapshot;
  final AsyncSnapshot<List>? inventorySnapshot;
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    if (historySnapshot != null) {
      if (historySnapshot!.data != null && historySnapshot!.data!.isNotEmpty) {
        return StreamBuilder<bool>(
            stream: theme.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Badge(
                  animationType: BadgeAnimationType.scale,
                  animationDuration: const Duration(milliseconds: 200),
                  position: BadgePosition.topEnd(top: 2, end: 4),
                  badgeColor:
                      snapshot.data! ? Colors.redAccent : Colors.orangeAccent,
                  badgeContent: Text(
                    historySnapshot!.data!.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontSize: 12, color: Colors.black),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogList(
                              historySnapshot: historySnapshot,
                              type: HistoryViewBlocEnum.history);
                        },
                      );
                    },
                    icon: HistoryPanelIcon(
                      theme: theme,
                      icon: Icons.view_list,
                    ),
                  ),
                );
              }
              return Container();
            });
      }
    } else if (inventorySnapshot != null) {
      if (inventorySnapshot!.data != null &&
          inventorySnapshot!.data!.isNotEmpty) {
        return StreamBuilder<bool>(
            stream: theme.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Badge(
                  animationType: BadgeAnimationType.scale,
                  animationDuration: const Duration(milliseconds: 200),
                  position: BadgePosition.topEnd(top: 2, end: 4),
                  badgeColor:
                      snapshot.data! ? Colors.redAccent : Colors.orangeAccent,
                  badgeContent: Text(
                    inventorySnapshot!.data!
                        .where((element) => element.bookMark == true)
                        .length
                        .toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontSize: 12, color: Colors.black),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogList(
                            inventorySnapshot: inventorySnapshot,
                            type: HistoryViewBlocEnum.inventory,
                          );
                        },
                      );
                    },
                    icon: HistoryPanelIcon(
                      theme: theme,
                      icon: Icons.bookmarks_outlined,
                    ),
                  ),
                );
              }
              return Container();
            });
      }
    }
    return Container();
  }
}

class HistoryPanelIcon extends StatelessWidget {
  const HistoryPanelIcon({
    Key? key,
    required this.theme,
    required this.icon,
  }) : super(key: key);

  final ThemeBloc theme;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: theme.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Icon(
                icon,
                size: 25,
                color: snapshot.data! == true
                    ? Styles.lightColor
                    : Styles.darkColor,
              );
            }
          }
          return Container();
        });
  }
}

class DialogList extends StatelessWidget {
  const DialogList({
    Key? key,
    required this.type,
    this.historySnapshot,
    this.inventorySnapshot,
  }) : super(key: key);

  final AsyncSnapshot<List>? inventorySnapshot;
  final AsyncSnapshot<List>? historySnapshot;
  final HistoryViewBlocEnum type;

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
                      final history = historySnapshot!.data![idx] as History;

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
