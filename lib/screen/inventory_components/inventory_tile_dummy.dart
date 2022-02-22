import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';
import 'package:stock_manager/bloc/inventory/inventory_bloc.dart';
import 'package:stock_manager/database/model/inventory_model.dart';
import 'package:stock_manager/database/repository/gsheet_handler.dart';

import '../../styles.dart';
import '../../utils/string_handler.dart';

class InventoryTiles extends StatelessWidget {
  const InventoryTiles({
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
        return InventoryTile(
          theme: theme,
          snapshot: snapshot,
          idx: idx,
          combiner: combiner,
          inventory: snapshot.data![idx],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey[700],
          thickness: 1.0,
        );
      },
    );
  }
}

class InventoryTile extends StatelessWidget {
  const InventoryTile({
    Key? key,
    required this.snapshot,
    required this.idx,
    required this.combiner,
    required this.inventory,
    this.theme,
  }) : super(key: key);

  final BlocsCombiner combiner;
  final AsyncSnapshot<List<Inventory>> snapshot;
  final int idx;
  final Inventory inventory;
  final ThemeBloc? theme;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
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
      child: Tiles(idx: idx, data: snapshot.data!, theme: theme),
    );
  }

  Future<bool?> checkDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
        return StreamBuilder(
            stream: theme.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return DeleteDialog(
                inventory: inventory,
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
            color: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Deal',
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(color: Colors.black),
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
            'Delete',
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(color: Colors.black),
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.delete,
            size: 30,
            color: Colors.black,
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
    required this.inventory,
  }) : super(key: key);

  final AsyncSnapshot<bool> themeSnapShot;
  final BlocsCombiner combiner;
  final String id;
  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          themeSnapShot.data == true ? Styles.darkColor : Styles.lightColor,
      title: Text(
        'Delete?',
        style: Theme.of(context).textTheme.headline2,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${inventory.title}(${inventory.memo})',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: innerSpacing),
          Text(
            'Qty: ${inventory.qty}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          child: Text(
            'Cancel',
            style:
                Theme.of(context).textTheme.headline3?.copyWith(fontSize: 14),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        OutlinedButton(
          child: Text(
            'Delete',
            style:
                Theme.of(context).textTheme.headline3?.copyWith(fontSize: 14),
          ),
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.yellow[600],
                content: Text(
                  'Pending: Processing Your Request',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(fontSize: 14),
                ),
                duration: const Duration(seconds: 1),
              ),
            );
            await combiner.inventoryBloc.delete(id).whenComplete(
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green[600],
                      content: Text(
                        'Success: Deleted Permanently',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                );
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
    this.theme,
  }) : super(key: key);

  final int idx;
  final List<Inventory> data;
  final ThemeBloc? theme;

  @override
  Widget build(BuildContext context) {
    final inventory = data[idx];
    final handler = SheetHandlerMain();
    final inventoryBloc = BlocProvider.of<BlocsCombiner>(context).inventoryBloc;

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      trailing: Text(
        inventory.qty.toString(),
        style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),
      ),
      leading: BookMarkUpdate(
        handler: handler,
        inventory: inventory,
        inventoryBloc: inventoryBloc,
      ),
      onTap: () {
        context.goNamed('inventoryDetails', extra: inventory);
      },
      title: Text(
        inventory.title.length > 15
            ? '${inventory.title.substring(0, 15).toTitleCase()}...${inventory.title.substring(inventory.title.length - 3, inventory.title.length).toTitleCase()}'
            : inventory.title.toTitleCase(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      subtitle: Text(
        inventory.memo.length > 15
            ? '${inventory.memo.substring(0, 15).toTitleCase()}...${inventory.memo.substring(inventory.memo.length - 3, inventory.memo.length).toTitleCase()}'
            : inventory.memo.toTitleCase(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}

class BookMarkUpdate extends StatelessWidget {
  const BookMarkUpdate({
    Key? key,
    required this.handler,
    required this.inventory,
    required this.inventoryBloc,
  }) : super(key: key);

  final SheetHandlerMain handler;
  final Inventory inventory;
  final InventoryBloc inventoryBloc;

  @override
  Widget build(BuildContext context) {
    final inventoryBloc = BlocProvider.of<BlocsCombiner>(context).inventoryBloc;
    final bookmark = BlocProvider.of<BlocsCombiner>(context).bookMarkView;
    return IconButton(
      onPressed: () async {
        await handler
            .updateOne(
              inventory.id,
              'bookMark',
              inventory.bookMark == true ? 'n' : 'y',
              SheetType.inventory,
            )
            .whenComplete(() => inventoryBloc.reload())
            .whenComplete(() => bookmark.push());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            content: Text(
              'Success: Bookmark Updated',
              style:
                  Theme.of(context).textTheme.headline4?.copyWith(fontSize: 14),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      icon: Icon(
        Icons.star_rounded,
        color: inventory.bookMark ? Colors.yellow[600] : Colors.grey[600],
        size: 30,
      ),
    );
  }
}
