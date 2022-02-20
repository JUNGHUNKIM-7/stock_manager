import 'package:flutter/material.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

class FilterBtns extends StatelessWidget {
  const FilterBtns({
    Key? key,
    required this.text,
    this.onPressed,
    this.bloc,
  }) : super(key: key);

  final String text;
  final Function()? onPressed;
  final dynamic bloc;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    return StreamBuilder(
      stream: bloc?.stream,
      builder: (context, AsyncSnapshot<bool> filterSnapShot) {
        return FilterButtonWithStream(
          theme: theme,
          onPressed: onPressed,
          text: text,
          filterSnapShot: filterSnapShot,
        );
      },
    );
  }
}

class FilterButtonWithStream extends StatelessWidget {
  const FilterButtonWithStream({
    Key? key,
    required this.theme,
    required this.onPressed,
    required this.text,
    required this.filterSnapShot,
  }) : super(key: key);

  final ThemeBloc theme;
  final Function()? onPressed;
  final String text;
  final AsyncSnapshot<bool> filterSnapShot;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: theme.stream,
        builder: (context, AsyncSnapshot<bool> themeSnapShot) {
          return Center(
            child: OutlinedButton(
              style: filterSnapShot.data == true
                  ? ButtonStyle(
                      backgroundColor: themeSnapShot.data == true
                          ? MaterialStateProperty.all(Colors.redAccent)
                          : MaterialStateProperty.all(Colors.orangeAccent),
                    )
                  : ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
              onPressed: onPressed,
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          );
        });
  }
}
