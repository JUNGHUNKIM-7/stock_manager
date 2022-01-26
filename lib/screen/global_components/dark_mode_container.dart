import 'package:flutter/material.dart';
import 'package:router_go/bloc/global/theme_bloc.dart';

import '../../styles.dart';

class DarkModeContainer extends StatelessWidget {
  const DarkModeContainer(
      {Key? key,
        required this.height,
        required this.child,
        this.align,
        this.reverse,
        this.theme})
      : super(key: key);

  final ThemeBloc? theme;
  final double height;
  final Widget child;
  final Alignment? align;
  final bool? reverse;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: theme?.stream,
      builder: (context, AsyncSnapshot<bool> snapshot) => Container(
        alignment: align ?? Alignment.center,
        height: MediaQuery.of(context).size.height * height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: reverse != null && reverse == true
              ? Styles.innerShadow
              : snapshot.data ?? theme?.state ?? false
              ? Styles.darkShadow
              : Styles.lightShadow,
        ),
        child: child,
      ),
    );
  }
}
