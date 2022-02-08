import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final inStatus = BlocProvider.of<BlocsCombiner>(context).inStatus;
    final outStatus = BlocProvider.of<BlocsCombiner>(context).outStatus;
    final descendingStatus =
        BlocProvider.of<BlocsCombiner>(context).descendingStatus;
    const historyBtnText = ['In', 'Out', 'DESC'];
    const inventoryBtnText = ['Import From Excel', 'Add'];

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
        return List.generate(
          2,
          (idx) => Row(
            children: [
              FilterBtns(
                  text: inventoryBtnText[idx],
                  onPressed: () {
                    if (idx == 0) {
                    } else {
                      context.goNamed('inventoryForm');
                    }
                  }),
              if (idx == 0)
                const SizedBox(
                  width: 4,
                )
            ],
          ),
        );
      default:
        throw Exception('Unknown btnType');
    }
  }
}
