import 'package:flutter/material.dart';
import 'package:qr_sheet_stock_manager/bloc/global/theme_bloc.dart';
import 'package:qr_sheet_stock_manager/styles.dart';

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
          return TextButton.icon(
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
            label: Text(
              snapshot.data ?? false ? 'Light Mode' : 'Dark Mode',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                  fontSize: 16,
                  color: snapshot.data ?? false
                      ? Styles.lightColor
                      : Styles.darkColor),
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
