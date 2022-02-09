import 'package:flutter/material.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';

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
          throw Exception('Dark Mode');
        }
        return Container();
      },
    );
  }
}
