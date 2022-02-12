import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/bloc/global/form_bloc.dart';
import 'package:router_go/bloc/global/history_view.dart';
import 'package:router_go/bloc/global/theme_bloc.dart';
import 'package:router_go/styles.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../database/repository/gsheet_handler.dart';
import 'dark_mode_toggle.dart';
import 'history_panel.dart';

AppBar showAppBar(BuildContext context, int pageIdx, ThemeBloc theme) {
  switch (pageIdx) {
    case 0:
      return AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) => AppBarSettingsBtn(theme: theme)),
        actions: [
          DarkModeToggle(
            iconSize: 30.0,
            theme: theme,
          ),
          const HistoryPanel(
            historyViewBlocEnum: HistoryViewBlocEnum.history,
          ),
          const SizedBox(
            width: 4.0,
          )
        ],
        title: MainHeader(
          title: 'History',
          theme: theme,
        ),
      );
    case 1:
      return AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => AppBarSettingsBtn(theme: theme),
        ),
        actions: [
          UserInventoryBtn(theme: theme),
          DarkModeToggle(
            iconSize: 30.0,
            theme: theme,
          ),
          const HistoryPanel(
            historyViewBlocEnum: HistoryViewBlocEnum.inventory,
          ),
          const SizedBox(
            width: 4.0,
          )
        ],
        title: MainHeader(
          title: 'Inventory',
          theme: theme,
        ),
      );
    default:
      return AppBar(
          automaticallyImplyLeading: false,
          leading:
              Builder(builder: (context) => AppBarSettingsBtn(theme: theme)),
          actions: [
            DarkModeToggle(
              iconSize: 30.0,
              theme: theme,
            ),
            const SizedBox(
              width: 4.0,
            )
          ],
          title: MainHeader(title: 'Stocks', theme: theme));
  }
}

class UserInventoryBtn extends StatelessWidget {
  const UserInventoryBtn({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    final inventoryBloc = BlocProvider.of<BlocsCombiner>(context).inventoryBloc;
    final handler = GSheetHandler();

    return IconButton(
      onPressed: () async {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.yellow[600],
              content: const Text('Pending: Processing Your Data'),
            ),
          );
          await handler.moveToInventoryAndBackUp();
          await inventoryBloc.reload();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[600],
              content: const Text(
                  'Success: All Items are Added to "inventory" Sheet'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[600],
              content: Text('Failed: ${e.toString().split(':')[1]}'),
            ),
          );
        }
      },
      icon: StreamBuilder<bool>(
          stream: theme.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Icon(
                  Icons.cloud_download,
                  size: 30,
                  color: snapshot.data! == true
                      ? Styles.lightColor
                      : Styles.darkColor,
                );
              }
            }
            return Container();
          }),
    );
  }
}

class MainHeader extends StatelessWidget {
  const MainHeader({Key? key, required this.title, required this.theme})
      : super(key: key);
  final String title;
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: theme.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Text(
                title,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 24,
                      color: snapshot.data! == true
                          ? Styles.lightColor
                          : Styles.darkColor,
                    ),
              );
            }
          }
          return Container();
        });
  }
}

class AppBarSettingsBtn extends StatelessWidget {
  const AppBarSettingsBtn({Key? key, required this.theme}) : super(key: key);
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: StreamBuilder<bool>(
          stream: theme.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Icon(
                  Icons.settings,
                  size: 25,
                  color: snapshot.data! == true
                      ? Styles.lightColor
                      : Styles.darkColor,
                );
              }
            }
            return Container();
          }),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}

AppBar showAppBarWithBackBtn({
  required BuildContext context,
  String? typeOfForm,
  BlocsCombiner? combiner,
}) =>
    AppBar(
      actions: [
        IconButton(
          onPressed: () {
            if (typeOfForm != null) {
              if (typeOfForm == 'history') {
                combiner?.statusFieldBloc.clearHistoryForm(FormFields.status);
                combiner?.valFieldBloc.clearHistoryForm(FormFields.val);
              }
              if (typeOfForm == 'inventory') {
                combiner?.titleFieldBloc.clearInventoryForm(FormFields.title);
                combiner?.memoFieldBloc.clearInventoryForm(FormFields.memo);
                combiner?.qtyFieldBloc.clearInventoryForm(FormFields.qty);
              }
              if (typeOfForm == 'historyDetails') {
                combiner?.historySearchBloc.onChanged('');
              }
              if (typeOfForm == 'inventoryDetails') {
                combiner?.inventorySearchBloc.onChanged('');
              }
            }
            context.goNamed('home');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(
          width: 4.0,
        ),
      ],
      title: typeOfForm == 'history'
          ? Text(
              'History Form'.toUpperCase(),
              style:
                  Theme.of(context).textTheme.headline1?.copyWith(fontSize: 24),
            )
          : typeOfForm == 'inventory'
              ? Text(
                  'Inventory Form'.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 24),
                )
              : typeOfForm == 'historyDetails'
                  ? Text(
                      'History Details'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 24),
                    )
                  : Text(
                      'Inventory Details'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 24),
                    ),
    );
