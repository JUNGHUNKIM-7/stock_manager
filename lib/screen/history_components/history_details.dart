import 'package:flutter/material.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/screen/global_components/appbar_icons.dart';
import 'package:stock_manager/screen/global_components/dark_mode_container.dart';
import 'package:stock_manager/screen/history_components/history_form_header.dart';
import 'package:stock_manager/styles.dart';

import '../../utils/string_handler.dart';

class HistoryDetails extends StatelessWidget {
  const HistoryDetails({
    Key? key,
    required this.history,
  }) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: showAppBarWithBackBtn(
            context: context, combiner: combiner, typeOfForm: 'historyDetails'),
        body: StreamBuilder<bool>(
            stream: theme.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "${history.title.toTitleCase()}'s Details",
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: outerSpacing * 1.5),
                    DarkModeContainer(
                      height: 0.20,
                      child: HistoryInfoCard(history: history),
                    ),
                    const SizedBox(height: outerSpacing),
                    DarkModeContainer(
                      theme: theme,
                      height: 0.55,
                      child: StreamByStatusWrapper(history: history),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class StreamByStatusWrapper extends StatelessWidget {
  const StreamByStatusWrapper({
    Key? key,
    required this.history,
  }) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: innerSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_business, color: Colors.limeAccent),
                  const SizedBox(width: innerSpacing),
                  Text(
                    'in'.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.copyWith(fontSize: 16, color: Colors.limeAccent),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.cyanAccent,
                  ),
                  const SizedBox(width: innerSpacing),
                  Text(
                    'out'.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.copyWith(fontSize: 16, color: Colors.cyanAccent),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: innerSpacing / 2, vertical: innerSpacing / 4),
          child: Divider(
            color: Colors.grey[700],
            thickness: 2,
            height: 2,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              StreamByStatus(history: history, type: 'in'),
              StreamByStatus(history: history, type: 'out')
            ],
          ),
        ),
      ],
    );
  }
}

class StreamByStatus extends StatelessWidget {
  const StreamByStatus({
    Key? key,
    required this.history,
    required this.type,
  }) : super(key: key);

  final History history;
  final String type;

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return StreamBuilder<List<History>>(
      stream: combiner.filterHisByStatus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: type == 'in'
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: innerSpacing / 2),
                    child: InWidget(history: history, snapshot: snapshot),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: innerSpacing / 2),
                    child: OutWidget(history: history, snapshot: snapshot),
                  ),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Text('No Data');
        }
        return Container();
      },
    );
  }
}

class OutWidget extends StatelessWidget {
  const OutWidget({
    Key? key,
    required this.history,
    required this.snapshot,
  }) : super(key: key);

  final History history;
  final AsyncSnapshot<List<History>> snapshot;

  @override
  Widget build(BuildContext context) {
    final outHistory = snapshot.data!
        .where((element) => element.id == history.id && element.status == 'y')
        .toList();
    return ListView.separated(
        itemBuilder: (context, idx) {
          final item = outHistory[idx];
          return ListTile(
            title: Text(
              '${item.date.toString().substring(0, 16)} ${item.jm}',
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14),
            ),
            trailing: Text(
              item.val.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.cyanAccent),
            ),
          );
        },
        separatorBuilder: (context, idx) {
          return Divider(
            color: Colors.grey[700],
            thickness: 1,
            height: 1,
          );
        },
        itemCount: outHistory.length);
  }
}

class InWidget extends StatelessWidget {
  const InWidget({
    Key? key,
    required this.history,
    required this.snapshot,
  }) : super(key: key);

  final History history;
  final AsyncSnapshot<List<History>> snapshot;

  @override
  Widget build(BuildContext context) {
    final inHistory = snapshot.data!
        .where((element) => element.id == history.id && element.status == 'n')
        .toList();
    return ListView.separated(
        itemBuilder: (context, idx) {
          final item = inHistory[idx];
          return ListTile(
            title: Text(
              '${item.date.toString().substring(0, 16)} ${item.jm}',
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14),
            ),
            trailing: Text(
              item.val.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.limeAccent),
            ),
          );
        },
        separatorBuilder: (context, idx) {
          return Divider(
            color: Colors.grey[700],
            thickness: 1,
            height: 1,
          );
        },
        itemCount: inHistory.length);
  }
}
