import 'package:flutter/material.dart';
import 'package:router_go/bloc/atom_blocs/filter_chip_bloc.dart';
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
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: Chips.months.length,
            itemBuilder: (context, idx) {
              return ChipOfList(
                idx: idx,
                snapshot: snapshot,
                months: months,
                chip: chip,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 8,
              );
            },
          );
        } else if (snapshot.error != null) {
          chip.dispose();
          throw Exception('ERR: FilterChip');
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
    required this.snapshot,
  }) : super(key: key);

  final List<String> months;
  final ChipBloc chip;
  final int idx;
  final AsyncSnapshot<int> snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: FilterChip(
        labelStyle: TextStyle(color: Colors.grey.shade400),
        checkmarkColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        backgroundColor: Colors.grey[600],
        selectedColor: Colors.grey[800],
        label: Text(Chips.months[idx].toUpperCase()),
        selected: snapshot.data == idx,
        onSelected: (bool selected) {
          if (selected) {
            chip.setIdx(idx);
          }
        },
      ),
    );
  }
}
