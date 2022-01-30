import 'package:flutter/material.dart';
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
          return StreamBuilder(
              stream: theme.stream,
              builder: (context, AsyncSnapshot<bool> themeSnapShot) {
                return OutlinedButton(
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
                        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                );
              });
        });
  }
}
