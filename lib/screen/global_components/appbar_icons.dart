import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

AppBar showAppBar(BuildContext context) => AppBar(
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

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({Key? key, required this.iconSize}) : super(key: key);
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    return StreamBuilder(
      stream: theme.stream,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return IconButton(
            onPressed: theme.darkMode,
            icon: snapshot.data ?? theme.state
                ? Icon(
                    Icons.wb_incandescent_outlined,
                    size: iconSize,
                  )
                : Icon(
                    Icons.wb_incandescent_rounded,
                    size: iconSize,
                  ),
          );
        } else if (snapshot.error != null) {
          theme.dispose();
          throw Exception('ERR: Dark Mode');
        }
        return Container();
      },
    );
  }
}
