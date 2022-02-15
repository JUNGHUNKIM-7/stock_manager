import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/screen/global_components/dark_mode_container.dart';

import '../../database/model/inventory_model.dart';
import '../../screen/global_components/appbar_icons.dart';
import '../../styles.dart';
import '../../utils/string_handler.dart';

class InventoryDetails extends StatelessWidget {
  const InventoryDetails({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: showAppBarWithBackBtn(
            context: context,
            combiner: combiner,
            typeOfForm: 'inventoryDetails'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<bool>(
                stream: combiner.themeBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return QrImage(
                      data: inventory.id,
                      version: QrVersions.auto,
                      size: 250,
                      backgroundColor: Colors.transparent,
                      foregroundColor:
                          snapshot.data! ? Styles.lightColor : Styles.darkColor,
                    );
                  }
                  return Container();
                }),
            const SizedBox(
              height: outerSpacing * 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
              child: DarkModeContainer(
                height: 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: innerSpacing * 2, vertical: innerSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Title'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(fontSize: 20),
                          ),
                          Divider(
                            color: Colors.grey[700],
                            thickness: 2.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              inventory.title.length > 32
                                  ? '${inventory.title.substring(0, 32)}...'
                                      .toTitleCase()
                                  : inventory.title.toTitleCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: innerSpacing),
                          Text(
                            'Item Memo'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(fontSize: 20),
                          ),
                          Divider(
                            color: Colors.grey[700],
                            thickness: 2.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              inventory.memo.length > 32
                                  ? '${inventory.memo.substring(0, 32)}...'
                                      .toTitleCase()
                                  : inventory.memo.toTitleCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: innerSpacing),
                          Text(
                            'current qty'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(fontSize: 20),
                          ),
                          Divider(
                            color: Colors.grey[700],
                            thickness: 2.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              inventory.qty.toString().length > 35
                                  ? '${inventory.qty.toString().substring(0, 35)}...'
                                  : inventory.qty.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: innerSpacing),
                          Text(
                            'Created Date'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(fontSize: 20),
                          ),
                          Divider(
                            color: Colors.grey[700],
                            thickness: 2.0,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              inventory.createAt.toString().substring(0, 10),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const InventoryDetailsBtns(),
                  ],
                ),
              ),
            ),
            //when press, navigate to e
          ],
        ),
      ),
    );
  }
}

class InventoryDetailsBtn extends StatelessWidget {
  const InventoryDetailsBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: const Text('Edit?'));
  }
}
