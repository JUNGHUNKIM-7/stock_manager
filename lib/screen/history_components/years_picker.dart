import 'package:flutter/material.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/provider.dart';
import 'package:qr_sheet_stock_manager/bloc/global/theme_bloc.dart';
import 'package:qr_sheet_stock_manager/styles.dart';

class Years extends StatelessWidget {
  const Years({Key? key, required this.theme}) : super(key: key);

  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    final year = BlocProvider.of<BlocsCombiner>(context).yearSelection;
    return StreamBuilder(
        stream: year.stream,
        builder: (context, AsyncSnapshot<int> yearSnapShot) {
          return StreamBuilder(
              stream: theme.stream,
              builder: (context, AsyncSnapshot<bool> themeSnapShot) {
                return PopupMenuButton(
                  padding: const EdgeInsets.symmetric(horizontal: innerSpacing),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  initialValue: yearSnapShot.data,
                  color: themeSnapShot.data == true
                      ? Styles.darkColor
                      : Styles.lightColor,
                  icon: themeSnapShot.data == true
                      ? const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Styles.lightColor,
                        )
                      : const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Styles.darkColor,
                        ),
                  iconSize: 40,
                  itemBuilder: (BuildContext context) =>
                      List.generate(yearSnapShot.data! ~/ 200, (index) {
                    return PopupMenuItem(
                      padding:
                          const EdgeInsets.symmetric(horizontal: innerSpacing),
                      value: yearSnapShot.data! + index,
                      textStyle: Theme.of(context).textTheme.bodyText1,
                      child: Center(
                        child: Text(
                          '${yearSnapShot.data! + index}',
                        ),
                      ),
                      onTap: () {
                        year.catchYear(yearSnapShot.data! + index);
                      },
                    );
                  }),
                );
              });
        });
  }
}
