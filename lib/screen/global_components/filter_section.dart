import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../styles.dart';
import 'filter_btns.dart';

class FilterSectionWithBtns extends StatelessWidget {
  const FilterSectionWithBtns({
    Key? key,
    required this.title,
    required this.btnType,
  }) : super(key: key);

  final String title;
  final String btnType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: innerSpacing * 1.5, vertical: innerSpacing / 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline3?.copyWith(
                  letterSpacing: 0.4,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: returnBtns(context, btnType),
          )
        ],
      ),
    );
  }

  List<Widget> returnBtns(BuildContext context, String btnType) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);
    final inStatus = combiner.inStatus;
    final outStatus = combiner.outStatus;
    final descendingStatus = combiner.descendingStatus;
    const historyBtnText = ['In', 'Out', 'DESC'];

    switch (btnType) {
      case 'history':
        return List.generate(3, (int idx) {
          return StreamBuilder(
              stream: idx == 0
                  ? inStatus.stream
                  : idx == 1
                      ? outStatus.stream
                      : descendingStatus.stream,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                return Row(
                  children: [
                    FilterBtns(
                      text: historyBtnText[idx],
                      onPressed: () {
                        if (idx == 0) {
                          inStatus.switchVal();
                        } else if (idx == 1) {
                          outStatus.switchVal();
                        } else {
                          descendingStatus.switchVal();
                        }
                      },
                      bloc: idx == 0
                          ? inStatus
                          : idx == 1
                              ? outStatus
                              : descendingStatus,
                    ),
                    if (idx == 0 || idx == 1)
                      const SizedBox(
                        width: 4,
                      )
                  ],
                );
              });
        });
      case 'inventory':
        return [
          FilterBtns(
            text: 'Add',
            onPressed: () => context.goNamed('inventoryForm'),
          )
        ];
      default:
        throw Exception('Unknown btnType');
    }
  }
}
