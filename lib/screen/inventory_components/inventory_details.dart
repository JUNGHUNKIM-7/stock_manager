import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';

import '../../database/model/inventory_model.dart';
import '../../screen/global_components/appbar_icons.dart';
import '../../styles.dart';

class InventoryDetails extends StatelessWidget {
  const InventoryDetails({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return Scaffold(
      appBar: showAppBarWithBackBtn(context, combiner: combiner),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: QrImage(
              data: inventory.id,
              version: QrVersions.auto,
              size: 250,
            ),
          ),
          const SizedBox(
            height: outerSpacing * 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    inventory.title,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  if (inventory.memo.isNotEmpty)
                    Text(
                      inventory.memo,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                ],
              ),
              Text(inventory.qty.toString(),
                  style: Theme.of(context).textTheme.headline1),
            ],
          ),
          const SizedBox(
            height: outerSpacing * 2,
          ),
          Center(
            child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Created at : ',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    TextSpan(
                        text: inventory.createAt
                            .toString()
                            .split(' ')[0]
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontSize: 24)),
                  ],
                ),
                style: Theme.of(context).textTheme.bodyText1),
          ),
          const SizedBox(
            height: outerSpacing * 2,
          ),
          //when press, navigate to e
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //navigate update form with Instance of inventory
              ElevatedButton(onPressed: () {}, child: const Text('Update?')),
              const SizedBox(
                width: outerSpacing,
              ),
              ElevatedButton(onPressed: () {}, child: const Text('Edit?')),
            ],
          ),
          const SizedBox(
            height: outerSpacing * 2,
          ),
        ],
      ),
    );
  }
}
