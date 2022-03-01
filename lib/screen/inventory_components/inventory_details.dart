import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/provider.dart';
import 'package:qr_sheet_stock_manager/screen/global_components/dark_mode_container.dart';

import '../../database/model/inventory_model.dart';
import '../../screen/global_components/appbar_wrapper.dart';
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
            child: DarkModeContainer(
              height: 0.85,
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<bool>(
                      stream: combiner.themeBloc.stream,
                      builder: (context, snapshot) {
                        return BarcodeWidget(
                          data: inventory.id,
                          width: 200,
                          height: 200,
                          color: snapshot.data ?? false
                              ? Styles.lightColor
                              : Styles.darkColor,
                          barcode: Barcode.qrCode(
                              errorCorrectLevel: BarcodeQRCorrectionLevel.high),
                        );
                      }),
                  const SizedBox(
                    height: outerSpacing * 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: outerSpacing * 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: innerSpacing * 2,
                              vertical: innerSpacing),
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
                                thickness: 1.0,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  inventory.title.length > 20
                                      ? '${inventory.title.substring(0, 20)}...'
                                          .toTitleCase()
                                      : inventory.title.toTitleCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: innerSpacing * 2),
                              Text(
                                'Item Memo'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(fontSize: 20),
                              ),
                              Divider(
                                color: Colors.grey[700],
                                thickness: 1.0,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  inventory.memo.length > 20
                                      ? '${inventory.memo.substring(0, 20)}...'
                                          .toTitleCase()
                                      : inventory.memo.toTitleCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: innerSpacing * 2),
                              Text(
                                'current qty'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(fontSize: 20),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: innerSpacing * 2),
                              Text(
                                'Created Date'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(fontSize: 20),
                              ),
                              Divider(
                                color: Colors.grey[700],
                                thickness: 1.0,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  inventory.createAt
                                      .toString()
                                      .substring(0, 10),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
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
                  //when press, navigate to e
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
