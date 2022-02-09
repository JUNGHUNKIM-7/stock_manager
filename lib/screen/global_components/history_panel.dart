import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/bloc/global/history_view.dart';
import 'package:router_go/bloc/global/theme_bloc.dart';
import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/styles.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({
    Key? key,
    this.historyViewBlocEnum,
  }) : super(key: key);
  final HistoryViewBlocEnum? historyViewBlocEnum;

  @override
  Widget build(BuildContext context) {
    if (historyViewBlocEnum == HistoryViewBlocEnum.history) {
      final historyHistory =
          BlocProvider.of<BlocsCombiner>(context).historyView;
      return StreamBuilder(
          stream: historyHistory.historyStream,
          builder: (context, AsyncSnapshot<List> snapshot) {
            return HistoryDialog(
              historySnapshot: snapshot,
            );
          });
    } else if (historyViewBlocEnum == HistoryViewBlocEnum.inventory) {
      final inventoryHistory =
          BlocProvider.of<BlocsCombiner>(context).inventoryView;
      return StreamBuilder(
          stream: inventoryHistory.inventoryStream,
          builder: (context, AsyncSnapshot<List> snapshot) {
            return HistoryDialog(
              inventorySnapshot: snapshot,
            );
          });
    } else {
      return Container();
    }
  }
}

class HistoryDialog extends StatelessWidget {
  const HistoryDialog({
    Key? key,
    this.historySnapshot,
    this.inventorySnapshot,
  }) : super(key: key);

  final AsyncSnapshot<List>? historySnapshot;
  final AsyncSnapshot<List>? inventorySnapshot;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
    if (historySnapshot != null) {
      if (historySnapshot!.data != null && historySnapshot!.data!.isNotEmpty) {
        return IconButton(
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
          icon: HistoryIcon(theme: theme),
        );
      }
    } else if (inventorySnapshot != null) {
      if (inventorySnapshot?.data != null &&
          inventorySnapshot!.data!.isNotEmpty) {
        return IconButton(
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
          icon: HistoryIcon(theme: theme),
        );
      }
    }
    return Container();
  }
}

class HistoryIcon extends StatelessWidget {
  const HistoryIcon({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: theme.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Icon(
                Icons.history,
                size: 30,
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
                    ? Colors.grey
                    : Colors.white.withOpacity(0.9),
                title: Text(
                  'Trade History',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 24),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  )
                ],
                content: SingleChildScrollView(
                  child: Column(
                    children:
                        List.generate(historySnapshot!.data!.length, (int idx) {
                      final history = historySnapshot!.data![idx] as History;
                      return ListTile(
                        trailing: Text('${history.val}'),
                        subtitle: Text('${history.date}'.substring(0, 10)),
                        title: history.title.length > 20
                            ? Text('${history.title.substring(0, 20)}...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(fontWeight: FontWeight.w600))
                            : Text(history.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(fontWeight: FontWeight.w600)),
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
                // actions:
              );
            });
      case HistoryViewBlocEnum.inventory:
        return StreamBuilder(
            stream: theme.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return AlertDialog(
                  backgroundColor: snapshot.data == true
                      ? Colors.grey
                      : Colors.white.withOpacity(0.9),
                  title: Text(
                    'Inventory\'s History',
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontSize: 24),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: List.generate(inventorySnapshot!.data!.length,
                          (int idx) {
                        final inventory =
                            inventorySnapshot?.data?[idx] as Inventory;
                        return ListTile(
                          leading: const Icon(Icons.history),
                          subtitle: Text(inventory.memo),
                          title: inventory.title.length > 20
                              ? Text('${inventory.title.substring(0, 20)}...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontWeight: FontWeight.w600))
                              : Text(inventory.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                          trailing: Text('${inventory.qty}'),
                          onTap: () => context.goNamed('inventoryDetails',
                              extra: inventory),
                        );
                      }),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    )
                  ]);
            });
      default:
        throw Exception('Unknown HistoryViewBlocEnum');
    }
  }
}
