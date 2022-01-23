import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/screen/global_components/healine_btns.dart';
import 'package:router_go/screen/home_components/history_view.dart';

import '../../styles.dart';
import '../../bloc/atom_blocs/theme_bloc.dart';
import '../global_components/dark_mode_container.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({
    Key? key,
    this.theme,
  }) : super(key: key);

  final ThemeBloc? theme;

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return StreamBuilder(
      stream: combiner.filterInventoryStream,
      builder: (context, AsyncSnapshot<List<Inventory>> snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadlineSectionWithBtns(
                title: '0 Items',
                btnType: 'inventory',
              ),
              Flexible(child: Center(child: Text(snapshot.error.toString()))),
            ],
          );
        } else if (snapshot.hasError) {
          combiner.inventorySearchBloc.dispose();
          combiner.inventoryBloc.dispose();
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadlineSectionWithBtns(
                title: '${snapshot.data!.length} items',
                btnType: 'inventory',
              ),
              Expanded(
                child: InventoryList(snapshot: snapshot, theme: theme),
              ),
            ],
          );
        }
      },
    );
  }
}

class InventoryList extends StatelessWidget {
  const InventoryList({
    Key? key,
    required this.theme,
    required this.snapshot,
  }) : super(key: key);

  final ThemeBloc? theme;
  final AsyncSnapshot<List<Inventory>> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
          vertical: innerSpacing, horizontal: innerSpacing),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, idx) {
        return DarkModeContainer(
          theme: theme,
          height: 0.1,
          reverse: true,
          //todo move and delete
          child: DismissibleWrapper(snapshot: snapshot, idx: idx),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: innerSpacing,
        );
      },
    );
  }
}

class DismissibleWrapper extends StatelessWidget {
  const DismissibleWrapper({
    Key? key,
    required this.snapshot,
    required this.idx,
  }) : super(key: key);

  final AsyncSnapshot<List<Inventory>> snapshot;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          //delete data to gsheet and screen
          print('hello world');
        }
      },
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Delete'),
                content: Text('Are you sure you want to delete this item?'),
                actions: [
                  OutlinedButton(
                    child: Text('Cancel'),
                    onPressed: () => context.pop(),
                  ),
                  OutlinedButton(
                    child: Text('Delete'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          );
        } else if (direction == DismissDirection.startToEnd) {}
        throw Exception('unsupported direction');
      },
      key: UniqueKey(),
      child: Tiles(idx: idx, data: snapshot.data!),
    );
  }
}

class Tiles extends StatelessWidget {
  const Tiles({
    Key? key,
    required this.idx,
    required this.data,
  }) : super(key: key);

  final int idx;
  final List<Inventory> data;

  @override
  Widget build(BuildContext context) {
    final inventory = data[idx];

    return ListTile(
      trailing: Text(inventory.qty.toString()),
      leading: QrImage(
        data: inventory.id,
        version: QrVersions.auto,
        size: 60,
      ),
      onTap: () => context.goNamed('check_qr', extra: inventory),
      title: Text(
        inventory.title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        inventory.memo,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
