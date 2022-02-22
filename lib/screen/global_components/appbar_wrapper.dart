import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';
import 'package:stock_manager/bloc/global/history_view.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../database/repository/gsheet_handler.dart';
import 'appbar_components.dart';
import 'dark_mode_toggle.dart';
import 'panel_main.dart';

AppBar showAppBar(BuildContext context, int pageIdx, ThemeBloc theme) {
  final handler = SheetHandlerMain();

  switch (pageIdx) {
    case 0:
      return AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) => Settings(theme: theme)),
        actions: [
          const PanelMain(
            historyViewBlocEnum: PanelEnum.history,
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
        actions: [
          PdfMaker(
            theme: theme,
            handler: handler,
          ),
          InputUserInventory(
            theme: theme,
            handler: handler,
          ),
          const PanelMain(
            historyViewBlocEnum: PanelEnum.inventory,
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
              Builder(builder: (context) => Settings(theme: theme)),
          actions: [
            DarkModeToggle(
              iconSize: 25,
              theme: theme,
            ),
            const SizedBox(
              width: 4.0,
            )
          ],
          title: MainHeader(title: 'Stocks', theme: theme));
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
              'History    Form'.toUpperCase(),
              style:
                  Theme.of(context).textTheme.headline1?.copyWith(fontSize: 18),
            )
          : typeOfForm == 'inventory'
              ? Text(
                  'Inventory    Form'.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 18),
                )
              : typeOfForm == 'historyDetails'
                  ? Text(
                      'History  Details'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 18),
                    )
                  : Text(
                      'Manual'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 18),
                    ),
    );
