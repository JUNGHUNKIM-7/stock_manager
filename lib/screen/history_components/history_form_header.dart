import 'package:flutter/material.dart';
import 'package:router_go/bloc/global/form_bloc.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/screen/history_components/history_form_field.dart';
import '../../utils/string_handler.dart';

import '../../styles.dart';

class HistoryFormCard extends StatelessWidget {
  const HistoryFormCard({
    Key? key,
    required this.inventory,
    required this.out,
    required this.val,
  }) : super(key: key);

  final Inventory inventory;
  final FormBloc out;
  final FormBloc val;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: innerSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatusSwitch(out: out),
          ProductDetails(inventory: inventory),
          HistoryFormField(val: val)
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
                    .headline2
                    ?.copyWith(fontSize: 24),
              )
            else
              Text(
                'in'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(fontSize: 24),
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

class ProductDetails extends StatelessWidget {
  const ProductDetails({
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
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 20),
          ),
          const Divider(
            color: Colors.black,
            thickness: 2.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              inventory.title.length > 32
                  ? '${inventory.title.substring(0, 32)}...'.toTitleCase()
                  : inventory.title.toTitleCase(),
              style:
                  Theme.of(context).textTheme.headline2?.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: innerSpacing * 1.5),
          Text(
            'Item Memo'.toUpperCase(),
            style:
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 20),
          ),
          const Divider(
            color: Colors.black,
            thickness: 2.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              inventory.memo.length > 32
                  ? '${inventory.memo.substring(0, 32)}...'.toTitleCase()
                  : inventory.memo.toTitleCase(),
              style:
                  Theme.of(context).textTheme.headline2?.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: innerSpacing * 1.5),
          Text(
            'Item Qty'.toUpperCase(),
            style:
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 20),
          ),
          const Divider(
            color: Colors.black,
            thickness: 2.0,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              inventory.qty.toString().length > 35
                  ? '${inventory.qty.toString().substring(0, 35)}...'
                  : inventory.qty.toString(),
              style:
                  Theme.of(context).textTheme.headline2?.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
