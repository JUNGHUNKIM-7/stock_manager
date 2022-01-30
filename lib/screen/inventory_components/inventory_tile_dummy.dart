import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/bloc/global/theme_bloc.dart';
import 'package:router_go/database/model/inventory_model.dart';
import '../../styles.dart';
import '../global_components/dark_mode_container.dart';
import '../../utils/string_handler.dart';

class InventoryList extends StatelessWidget {
  const InventoryList({
    Key? key,
    required this.theme,
    required this.snapshot,
    required this.combiner,
  }) : super(key: key);

  final ThemeBloc? theme;
  final AsyncSnapshot<List<Inventory>> snapshot;
  final BlocsCombiner combiner;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
          vertical: innerSpacing, horizontal: innerSpacing),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, idx) {
        return DarkModeContainer(
          theme: theme,
          height: 0.09,
          reverse: true,
          child: DismissibleWrapper(
            snapshot: snapshot,
            idx: idx,
            combiner: combiner,
            inventory: snapshot.data![idx],
          ),
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
    required this.combiner,
    required this.inventory,
  }) : super(key: key);

  final BlocsCombiner combiner;
  final AsyncSnapshot<List<Inventory>> snapshot;
  final int idx;
  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      dragStartBehavior: DragStartBehavior.down,
      secondaryBackground: const SecondBackGround(),
      background: const PrimaryBackGround(),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return checkDeleteDialog(context);
        } else if (direction == DismissDirection.startToEnd) {
          context.goNamed('historyForm', extra: inventory);
        }
        return Future.value(false);
      },
      key: ValueKey(inventory.id),
      child: Tiles(idx: idx, data: snapshot.data!),
    );
  }

  Future<bool?> checkDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
        return StreamBuilder(
            stream: theme.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return DeleteDialog(
                themeSnapShot: snapshot,
                combiner: combiner,
                id: inventory.id,
              );
            });
      },
    );
  }
}

class PrimaryBackGround extends StatelessWidget {
  const PrimaryBackGround({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.playlist_add,
            size: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Make a Deal',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}

class SecondBackGround extends StatelessWidget {
  const SecondBackGround({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Delete Item',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.delete,
            size: 30,
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    required this.combiner,
    required this.id,
    required this.themeSnapShot,
  }) : super(key: key);

  final AsyncSnapshot<bool> themeSnapShot;
  final BlocsCombiner combiner;
  final String id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: themeSnapShot.data == true
          ? Colors.grey
          : Colors.white.withOpacity(0.9),
      title: Text(
        'Delete Item?',
        style: Theme.of(context).textTheme.headline2,
      ),
      content: Text(
        'Are you sure you want to delete this item?',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: [
        OutlinedButton(
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          //FIX goRouter
          onPressed: () => Navigator.of(context).pop(),
        ),
        OutlinedButton(
          child: Text(
            'Delete',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () async {
            await combiner.inventoryBloc.delete(id).whenComplete(
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item Deleted'),
                    ),
                  ),
                );
            //FIX goRouter
            Navigator.of(context).pop();
          },
        ),
      ],
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
    final inventoryHistory =
        BlocProvider.of<BlocsCombiner>(context).inventoryView;

    return ListTile(
      trailing: Text(
        inventory.qty.toString(),
        style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16),
      ),
      dense: true,
      leading: QrImage(
        data: inventory.id,
        version: QrVersions.auto,
        size: 60,
      ),
      onTap: () {
        inventoryHistory.push(inventory);
        context.goNamed('inventoryDetails', extra: inventory);
      },
      title: Text(
        inventory.title.length > 12
            ? '${inventory.title.substring(0, 12)}...'.toTitleCase()
            : inventory.title.toTitleCase(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        inventory.memo.length > 12
            ? '${inventory.memo.substring(0, 12)}...'.toTitleCase()
            : inventory.memo.toTitleCase(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
