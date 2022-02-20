import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/history_view.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';
import 'package:stock_manager/styles.dart';

import '../../database/model/history_model.dart';
import 'dialog_pop_up.dart';

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
          builder: (context, AsyncSnapshot<List<History>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return HistoryDialog(
                    theme: theme,
                    historySnapshot: snapshot,
                    clean: () =>
                        historyHistory.clear(HistoryViewBlocEnum.history));
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
      required this.theme,
      this.clean})
      : super(key: key);

  final AsyncSnapshot<List<History>>? historySnapshot;
  final AsyncSnapshot<List>? inventorySnapshot;
  final ThemeBloc theme;
  final void Function()? clean;

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
                          return DialogPopUp(
                              historySnapshot: historySnapshot,
                              type: HistoryViewBlocEnum.history,
                              clean: clean);
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
                          return DialogPopUp(
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
