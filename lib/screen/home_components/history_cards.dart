import 'package:flutter/material.dart';
import 'package:router_go/bloc/atom_blocs/theme_bloc.dart';

import '../../styles.dart';

class CardListView extends StatelessWidget {
  const CardListView({
    Key? key,
    required this.theme,
    required this.snapshot,
  }) : super(key: key);

  final ThemeBloc theme;
  final AsyncSnapshot<List> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: innerSpace,
      ),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, idx) {
        final card = snapshot.data?[idx];

        return Padding(
          padding: const EdgeInsets.only(top: innerSpace),
          child: EachCard(
              theme: theme,
              out: card.out,
              title: card.title,
              qty: card.qty,
              date: card.date,
              time: card.time),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: innerSpace / 4,
        );
      },
    );
  }
}

class EachCard extends StatelessWidget {
  const EachCard(
      {Key? key,
      required this.out,
      required this.title,
      this.date,
      required this.theme,
      required this.qty,
      required this.time})
      : super(key: key);

  final String out;
  final String title;
  final int qty;
  final ThemeBloc theme;
  final String? date;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: theme.stream,
      builder: (context, snapshot) => Container(
        decoration: BoxDecoration(
          color: snapshot.data == true ? Styles.darkColor : Styles.lightColor,
          boxShadow: Styles.innerShadow,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: innerSpace, vertical: innerSpace),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(date!),
                  Text(time!),
                ],
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Text(title),
              ),
              Text(qty.toString()),
              const SizedBox(
                width: 14,
              ),
              if (out.toLowerCase() == 'y')
                const Icon(
                  Icons.arrow_circle_up_outlined,
                  color: Color(0xffD946EF),
                  size: 30,
                )
              else
                const Icon(
                  Icons.arrow_circle_down_outlined,
                  color: Color(0xff4ADE80),
                  size: 30,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
