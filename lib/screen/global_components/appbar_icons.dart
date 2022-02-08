import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/global/form_bloc.dart';
import 'package:router_go/bloc/global/history_view.dart';

import '../../bloc/constant/blocs_combiner.dart';
import 'history_panel.dart';
import 'dark_mode_toggle.dart';

AppBar showAppBar(
  BuildContext context,
  int pageIdx,
) {
  switch (pageIdx) {
    case 0:
      return AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          HistoryPanel(
            historyViewBlocEnum: HistoryViewBlocEnum.history,
          ),
          DarkModeToggle(iconSize: 30.0),
          SizedBox(
            width: 4.0,
          )
        ],
        title: Text(
          'STOCKS',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    case 1:
      return AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          HistoryPanel(
            historyViewBlocEnum: HistoryViewBlocEnum.inventory,
          ),
          DarkModeToggle(iconSize: 30.0),
          SizedBox(
            width: 4.0,
          )
        ],
        title: Text(
          'STOCKS',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    default:
      return AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          DarkModeToggle(iconSize: 30.0),
          SizedBox(
            width: 4.0,
          )
        ],
        title: Text(
          'STOCKS',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
  }
}

AppBar showAppBarWithBackBtn(BuildContext context, {BlocsCombiner? combiner}) =>
    AppBar(
      actions: [
        const DarkModeToggle(iconSize: 30.0),
        const SizedBox(
          width: 4.0,
        ),
        IconButton(
          onPressed: () {
            combiner?.titleFieldBloc.clearInventoryForm(FormFields.title);
            combiner?.memoFieldBloc.clearInventoryForm(FormFields.memo);
            combiner?.qtyFieldBloc.clearInventoryForm(FormFields.qty);
            combiner?.statusFieldBloc.clearHistoryForm(FormFields.status);
            combiner?.valFieldBloc.clearHistoryForm(FormFields.val);
            combiner?.historySearchBloc.onChanged('');
            combiner?.inventorySearchBloc.onChanged('');

            context.goNamed('home');
          },
          icon: const Icon(Icons.arrow_back),
        )
      ],
      title: Text(
        'STOCKS',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
