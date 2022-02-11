import 'package:flutter/material.dart';
import 'package:router_go/bloc/global/theme_bloc.dart';
import 'package:router_go/styles.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({Key? key, required this.theme, required this.iconSize})
      : super(key: key);
  final double iconSize;
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
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
                    color: Styles.lightColor,
                  )
                : Icon(
                    Icons.wb_incandescent_rounded,
                    size: iconSize,
                    color: Styles.darkColor,
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
