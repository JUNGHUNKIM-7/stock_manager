import 'package:flutter/material.dart';
import 'package:inventory_tracker/bloc/history/chip_bloc.dart';
import 'package:inventory_tracker/styles.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

class Chips extends StatelessWidget {
  const Chips({
    Key? key,
  }) : super(key: key);

  static final months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec',
  ];

  @override
  Widget build(BuildContext context) {
    final chip = BlocProvider.of<BlocsCombiner>(context).chipBloc;

    return StreamBuilder(
      stream: chip.stream,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.active) {}
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: Chips.months.length,
            itemBuilder: (context, idx) {
              if (snapshot.connectionState == ConnectionState.active) {
                return ChipOfList(
                  idx: idx,
                  idxSnapShot: snapshot,
                  months: months,
                  chip: chip,
                );
              }
              return Container();
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 8,
              );
            },
          );
        } else if (snapshot.error != null) {
          chip.dispose();
          throw Exception('FilterChip');
        }
        return Container();
      },
    );
  }
}

class ChipOfList extends StatelessWidget {
  const ChipOfList({
    Key? key,
    required this.months,
    required this.chip,
    required this.idx,
    required this.idxSnapShot,
  }) : super(key: key);

  final List<String> months;
  final ChipBloc chip;
  final int idx;
  final AsyncSnapshot<int> idxSnapShot;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: StreamBuilder(
          stream: theme.stream,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return FilterChip(
                selectedColor: snapshot.data == true
                    ? Styles.darkColor
                    : Styles.lightColor,
                checkmarkColor: snapshot.data == true
                    ? Styles.lightColor
                    : Styles.darkColor,
                showCheckmark: true,
                labelStyle: snapshot.data == true
                    ? Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(color: Styles.lightColor)
                    : Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(color: Styles.darkColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: snapshot.data == true
                        ? Styles.lightColor
                        : Styles.darkColor,
                  ),
                ),
                backgroundColor: snapshot.data == true
                    ? Styles.darkColor
                    : Styles.lightColor,
                label: Text(Chips.months[idx].toUpperCase()),
                selected: idxSnapShot.data == idx,
                onSelected: (bool selected) {
                  if (selected) {
                    chip.setIdx(idx);
                  }
                },
              );
            }
            return Container();
          }),
    );
  }
}
