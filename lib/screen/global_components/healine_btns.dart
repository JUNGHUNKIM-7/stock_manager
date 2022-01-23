import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';

import '../../styles.dart';
import 'lined_btn_set.dart';

class HeadlineSectionWithBtns extends StatelessWidget {
  const HeadlineSectionWithBtns({
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
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 24),
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
    const historyBtnText = ['In', 'Out'];
    const inventoryBtnText = ['Add'];

    switch (btnType) {
      case 'history':
        return List.generate(2, (int idx) {
          return StreamBuilder(
              stream: idx == 0 ? inStatus.stream : outStatus.stream,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                return Row(
                  children: [
                    LinedBtn(
                      text: historyBtnText[idx],
                      onPressed: () {
                        if (idx == 0) {
                          inStatus.switchVal();
                        } else {
                          outStatus.switchVal();
                        }
                      },
                      bloc: idx == 0 ? inStatus : outStatus,
                    ),
                    if (idx == 0)
                      const SizedBox(
                        width: 8,
                      )
                  ],
                );
              });
        });
      case 'inventory':
        return List.generate(1, (int idx) {
          return LinedBtn(
            text: inventoryBtnText[idx],
            onPressed: () {
              context.goNamed('addItem');
            },
          );
        });
      default:
        throw Exception('Not Implemented : Filter Btns');
    }
  }
}
