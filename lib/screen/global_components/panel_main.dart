import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/history_view.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';
import 'package:stock_manager/styles.dart';

import '../../database/model/history_model.dart';
import '../../database/model/inventory_model.dart';
import 'dialog_pop_up.dart';

class PanelMain extends StatelessWidget {
  const PanelMain({
    Key? key,
    this.historyViewBlocEnum,
  }) : super(key: key);
  final PanelEnum? historyViewBlocEnum;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    if (historyViewBlocEnum == PanelEnum.history) {
      final historyPanel = BlocProvider.of<BlocsCombiner>(context).historyView;
      return StreamBuilder(
          stream: historyPanel.historyStream,
          builder: (context, AsyncSnapshot<List<History>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return PanelDialog(
                    theme: theme,
                    historyViewSnapShot: snapshot,
                    clean: () => historyPanel.clear(PanelEnum.history));
              }
            }
            return Container();
          });
    } else if (historyViewBlocEnum == PanelEnum.inventory) {
      final bookMarkView = BlocProvider.of<BlocsCombiner>(context).bookMarkView;

      return StreamBuilder(
          stream: bookMarkView.bookMarkStream,
          builder: (context, AsyncSnapshot<List<Inventory>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return PanelDialog(
                  theme: theme,
                  bookMarkViewSnapShot: snapshot,
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

class PanelDialog extends StatelessWidget {
  const PanelDialog(
      {Key? key,
      this.historyViewSnapShot,
      this.bookMarkViewSnapShot,
      required this.theme,
      this.clean})
      : super(key: key);

  final AsyncSnapshot<List<History>>? historyViewSnapShot;
  final AsyncSnapshot<List<Inventory>>? bookMarkViewSnapShot;
  final ThemeBloc theme;
  final void Function()? clean;

  @override
  Widget build(BuildContext context) {
    if (historyViewSnapShot != null) {
      if (historyViewSnapShot!.data != null &&
          historyViewSnapShot!.data!.isNotEmpty) {
        return StreamBuilder<bool>(
            stream: theme.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Badge(
                  animationType: BadgeAnimationType.scale,
                  animationDuration: const Duration(milliseconds: 200),
                  position: BadgePosition.topEnd(top: 2, end: 4),
                  badgeColor:
                      snapshot.data! ? Colors.redAccent : Colors.amber,
                  badgeContent: Text(
                    historyViewSnapShot!.data!.length.toString(),
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
                              historySnapshot: historyViewSnapShot,
                              type: PanelEnum.history,
                              clean: clean);
                        },
                      );
                    },
                    icon: PanelIcon(
                      theme: theme,
                      icon: Icons.view_list,
                    ),
                  ),
                );
              }
              return Container();
            });
      }
    } else if (bookMarkViewSnapShot != null) {
      if (bookMarkViewSnapShot!.data != null &&
          bookMarkViewSnapShot!.data!.isNotEmpty) {
        return StreamBuilder<bool>(
            stream: theme.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Badge(
                  animationType: BadgeAnimationType.scale,
                  animationDuration: const Duration(milliseconds: 200),
                  position: BadgePosition.topEnd(top: 2, end: 4),
                  badgeColor:
                      snapshot.data! ? Colors.redAccent : Colors.amber,
                  badgeContent: Text(
                    bookMarkViewSnapShot!.data!.length.toString(),
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
                            bookMarkSnapShot: bookMarkViewSnapShot,
                            type: PanelEnum.inventory,
                          );
                        },
                      );
                    },
                    icon: PanelIcon(
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

class PanelIcon extends StatelessWidget {
  const PanelIcon({
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
