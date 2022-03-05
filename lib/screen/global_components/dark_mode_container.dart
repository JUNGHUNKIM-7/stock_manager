import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_sheet_stock_manager/bloc/global/theme_bloc.dart';

import '../../styles.dart';

class DarkModeContainer extends HookWidget {
  const DarkModeContainer({
    Key? key,
    required this.height,
    required this.child,
    this.align,
    this.reverse,
    this.theme,
  }) : super(key: key);

  final ThemeBloc? theme;
  final double height;
  final Widget child;
  final Alignment? align;
  final bool? reverse;

  @override
  Widget build(BuildContext context) {
    final themeStream = useStream(theme?.stream);

    return Container(
      alignment: align ?? Alignment.center,
      height: MediaQuery.of(context).size.height * height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: reverse != null && reverse == true
            ? Styles.innerShadow
            : themeStream.hasData && themeStream.data!
                ? Styles.darkShadow
                : Styles.lightShadow,
      ),
      child: child,
    );
  }
}
