import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_tracker/bloc/constant/provider.dart';
import 'package:inventory_tracker/bloc/global/form_bloc.dart';
import 'package:inventory_tracker/bloc/global/history_view.dart';
import 'package:inventory_tracker/bloc/global/selected_subscription.dart';
import 'package:inventory_tracker/bloc/global/theme_bloc.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../database/utils/gsheet_handler.dart';
import 'appbar_components.dart';
import 'dark_mode_toggle.dart';
import 'panel_main.dart';

AppBar showAppBar(BuildContext context, int pageIdx, ThemeBloc theme) {
  final handler = SheetHandlerMain();
  final settings = BlocProvider.of<BlocsCombiner>(context).settings;

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
          StreamBuilder<Map<String, dynamic>>(
              stream: settings.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!['secret'].isNotEmpty &&
                      snapshot.data!['sheetId'].isNotEmpty) {
                    return PdfMaker(
                      theme: theme,
                      handler: handler,
                    );
                  }
                }
                return Container();
              }),
          StreamBuilder<Map<String, dynamic>>(
              stream: settings.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!['secret'].isNotEmpty &&
                      snapshot.data!['sheetId'].isNotEmpty) {
                    return UserInventory(
                      theme: theme,
                      handler: handler,
                    );
                  }
                }
                return Container();
              }),
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
          leading: Builder(builder: (context) => Settings(theme: theme)),
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
  SelectedSubscriptionBloc? selectedPlan,
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
              if (typeOfForm == 'subscription') {
                selectedPlan?.clear();
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
      title: returnTextWidget(context, typeOfForm!),
    );

Widget returnTextWidget(BuildContext context, String typeOfForm) {
  Widget _textWidget(String text) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 18),
    );
  }

  switch (typeOfForm) {
    case 'history':
      return _textWidget('History   Form');
    case 'inventory':
      return _textWidget('Inventory   Form');
    case 'historyDetails':
      return _textWidget('History   Details');
    case 'inventoryDetails':
      return _textWidget('Inventory   Details');
    case 'manual':
      return _textWidget('Manual');
    case 'qr':
      return _textWidget('Qr   Camera');
    case 'features':
      return _textWidget('Features');
    case 'subscription':
      return _textWidget('subscription   plan');
    default:
      throw Exception('Not Found Any  of Form');
  }
}
