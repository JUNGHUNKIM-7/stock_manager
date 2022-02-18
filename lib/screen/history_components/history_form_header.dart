import 'package:flutter/material.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/database/model/inventory_model.dart';
import 'package:stock_manager/screen/history_components/history_form_field.dart';

import '../../styles.dart';
import '../../utils/string_handler.dart';

class HistoryInfoCard extends StatelessWidget {
  const HistoryInfoCard({
    Key? key,
    this.inventory,
    this.out,
    this.val,
    this.history,
  }) : super(key: key);

  final Inventory? inventory;
  final History? history;
  final FormBloc? out;
  final FormBloc? val;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: innerSpacing, vertical: innerSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (out != null) StatusSwitch(out: out!),
          if (inventory != null)
            ItemDetails(inventory: inventory!)
          else if (history != null)
            HistoryDetails(history: history!),
          if (val != null) HistoryFormFields(val: val!)
        ],
      ),
    );
  }
}

class StatusSwitch extends StatelessWidget {
  const StatusSwitch({
    Key? key,
    required this.out,
  }) : super(key: key);

  final FormBloc out;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: out.outStream,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (snapshot.data == 'y')
              Text(
                'out'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontSize: 20),
              )
            else
              Text(
                'in'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontSize: 20),
              ),
            Switch(
              inactiveTrackColor: Colors.limeAccent,
              activeColor: Colors.cyanAccent,
              value: snapshot.data == 'y' ? true : false,
              onChanged: (bool value) {
                if (value == true) {
                  out.getValue('y', FormFields.status);
                } else {
                  out.getValue('n', FormFields.status);
                }
              },
            )
          ],
        );
      },
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({
    Key? key,
    required this.inventory,
  }) : super(key: key);

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: innerSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Title'.toUpperCase(),
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 20),
          ),
          Divider(
            color: Colors.grey[700],
            thickness: 1.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              inventory.title.length > 32
                  ? '${inventory.title.substring(0, 32)}...'.toTitleCase()
                  : inventory.title.toTitleCase(),
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: innerSpacing),
          Text(
            'Item Memo'.toUpperCase(),
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 20),
          ),
          Divider(
            color: Colors.grey[700],
            thickness: 1.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              inventory.memo.length > 32
                  ? '${inventory.memo.substring(0, 32)}...'.toTitleCase()
                  : inventory.memo.toTitleCase(),
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: innerSpacing),
          Text(
            'Current Qty'.toUpperCase(),
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 20),
          ),
          Divider(
            color: Colors.grey[700],
            thickness: 1.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              inventory.qty.toString().length > 35
                  ? '${inventory.qty.toString().substring(0, 35)}...'
                  : inventory.qty.toString(),
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryDetails extends StatelessWidget {
  const HistoryDetails({Key? key, required this.history}) : super(key: key);
  final History history;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: innerSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Memo'.toUpperCase(),
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 18),
          ),
          Divider(
            color: Colors.grey[700],
            thickness: 1.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              (history.memo ?? '').length > 32
                  ? '${history.memo?.substring(0, 32)}...'.toTitleCase()
                  : history.memo?.toTitleCase() ?? '',
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Qty'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(fontSize: 18),
              ),
              Text(
                '- applied qty from latest transaction'.toTitleCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(fontSize: 14),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[700],
            thickness: 1.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              history.qty.toString().length > 35
                  ? '${history.qty.toString().substring(0, 35)}...'
                  : history.qty.toString(),
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
