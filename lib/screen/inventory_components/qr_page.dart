import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/screen/global_components/appbar_icons.dart';
import 'package:router_go/styles.dart';

class QrPage extends StatelessWidget {
  const QrPage({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBarWithBackBtn(context),
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
          const SizedBox(height: outerSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    inventory.title,
                    style: Theme.of(context).textTheme.headline2,
                  ),
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
            child: Text(inventory.createAt.toString().split(' ')[0],
                style: Theme.of(context).textTheme.headline2),
          ),
          const SizedBox(
            height: outerSpacing * 2,
          ),
        ],
      ),
    );
  }
}
//todo edit qty
//todo update to history
