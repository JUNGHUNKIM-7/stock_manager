import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/provider.dart';
import 'package:qr_sheet_stock_manager/bloc/global/theme_bloc.dart';
import 'package:qr_sheet_stock_manager/styles.dart';

class Years extends HookWidget {
  const Years({Key? key, required this.theme}) : super(key: key);
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    final year = BlocProvider.of<BlocsCombiner>(context).yearSelection;
    final yearStream = useStream(year.stream);
    final themeStream = useStream(theme.stream);
    final defaultDate = DateTime.now().year;

    return PopupMenuButton(
      padding: const EdgeInsets.symmetric(horizontal: innerSpacing),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      initialValue: DateTime.now().year,
      color: themeStream.data == true ? Styles.darkColor : Styles.lightColor,
      icon: themeStream.data == true
          ? const Icon(
              Icons.date_range,
              color: Styles.lightColor,
            )
          : const Icon(
              Icons.date_range,
              color: Styles.darkColor,
            ),
      iconSize: 25,
      tooltip: 'Select Year',
      itemBuilder: (BuildContext context) => yearStream.hasData &&
              yearStream.data != null
          ? List.generate(yearStream.data! ~/ 200, (index) {
              return PopupMenuItem(
                padding: const EdgeInsets.symmetric(horizontal: innerSpacing),
                value: yearStream.data! + index,
                textStyle: Theme.of(context).textTheme.bodyText1,
                child: Center(
                  child: Column(
                    children: [
                      if ((yearStream.data!) + index == DateTime.now().year)
                        Text(
                          'Current Year',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 16),
                        ),
                      SizedBox(height: innerSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if ((yearStream.data!) + index == DateTime.now().year)
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                            ),
                          SizedBox(width: 10),
                          Text(
                            '${yearStream.data! + index}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  year.catchYear(yearStream.data! + index);
                },
              );
            })
          : [],
    );
  }
}
