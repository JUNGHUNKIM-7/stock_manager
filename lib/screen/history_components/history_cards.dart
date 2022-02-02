import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/bloc/global/theme_bloc.dart';
import 'package:router_go/database/model/history_model.dart';
import '../../utils/string_handler.dart';

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
        horizontal: innerSpacing,
      ),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, idx) {
        final history = snapshot.data?[idx];

        return Padding(
          padding: const EdgeInsets.only(top: innerSpacing),
          child: Cards(
            history: history,
            theme: theme,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: innerSpacing / 4,
        );
      },
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
    required this.history,
    required this.theme,
  }) : super(key: key);

  final History history;
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    final historyHistory = BlocProvider.of<BlocsCombiner>(context).historyView;

    return GestureDetector(
      onTap: () {
        historyHistory.push(history);
        context.goNamed('historyDetails', extra: history);
      },
      child: StreamBuilder(
        stream: theme.stream,
        builder: (context, snapshot) => Container(
          decoration: BoxDecoration(
            color: snapshot.data == true ? Styles.darkColor : Styles.lightColor,
            boxShadow: Styles.innerShadow,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: innerSpacing,
              vertical: innerSpacing,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      history.date!.split(' ')[0],
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          ?.copyWith(fontSize: 14),
                    ),
                    Row(
                      children: [
                        Text(
                          history.date!.split(' ')[1].substring(0, 5),
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(fontSize: 14),
                        ),
                        const SizedBox(width: innerSpacing / 2),
                        Text(
                          history.jm!,
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: innerSpacing * 1.5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      history.title.length > 10
                          ? Text(
                              '${history.title.substring(0, 10)}...'
                                  .toTitleCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 16),
                            )
                          : Text(
                              history.title.toTitleCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 16),
                            ),
                      Text(
                        (history.memo ?? '').length > 32
                            ? '${history.memo?.substring(0, 32)}...'
                                .toTitleCase()
                            : history.memo?.toTitleCase() ?? '',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Text(
                  history.val.toString(),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: history.status == 'y'
                          ? Colors.cyanAccent
                          : Colors.limeAccent),
                ),
                const SizedBox(width: innerSpacing),
                if (history.status.toLowerCase() == 'y')
                  const Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.cyanAccent,
                    size: 26,
                  )
                else
                  const Icon(
                    Icons.add_business,
                    color: Colors.limeAccent,
                    size: 26,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
