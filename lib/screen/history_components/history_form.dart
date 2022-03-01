import 'package:flutter/material.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/blocs_combiner.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/provider.dart';
import 'package:qr_sheet_stock_manager/database/model/inventory_model.dart';
import 'package:qr_sheet_stock_manager/database/utils/gsheet_handler.dart';
import 'package:qr_sheet_stock_manager/screen/global_components/appbar_wrapper.dart';
import 'package:qr_sheet_stock_manager/screen/global_components/dark_mode_container.dart';

import '../../styles.dart';
import 'history_form_btn.dart';
import 'history_form_header.dart';

class HistoryForm extends StatelessWidget {
  HistoryForm({Key? key, required this.inventory}) : super(key: key);
  final Inventory inventory;
  final SheetHandlerMain _handler = SheetHandlerMain();

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);
    final out = BlocProvider.of<BlocsCombiner>(context).statusFieldBloc;
    final val = BlocProvider.of<BlocsCombiner>(context).valFieldBloc;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: showAppBarWithBackBtn(
            context: context, combiner: combiner, typeOfForm: 'history'),
        body: ListView(
          children: [
            const SizedBox(
              height: outerSpacing,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
              child: Center(
                child: Text(
                  'Make Order'.toUpperCase(),
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontSize: 22,
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: outerSpacing * 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: outerSpacing * 1.5),
              child: DarkModeContainer(
                height: height * 0.00085,
                reverse: true,
                child:
                    HistoryInfoCard(inventory: inventory, out: out, val: val),
              ),
            ),
            const SizedBox(
              height: outerSpacing,
            ),
            Center(
              child: SubmitHistory(handler: _handler, inventory: inventory),
            ),
          ],
        ),
      ),
    );
  }
}
