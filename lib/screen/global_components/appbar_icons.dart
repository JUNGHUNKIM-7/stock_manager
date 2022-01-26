import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/constant/blocs_combiner.dart';
import 'appbar_behavior.dart';

AppBar showAppBar(BuildContext context) => AppBar(
      actions: const [
        HistorySearch(),
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

AppBar showAppBarWithBackBtn(BuildContext context, {BlocsCombiner? combiner}) =>
    AppBar(
      actions: [
        const DarkModeToggle(iconSize: 30.0),
        const SizedBox(
          width: 4.0,
        ),
        IconButton(
          onPressed: () {
            combiner?.titleField.clear();
            combiner?.memoField.clear();
            combiner?.qtyField.clear();
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
